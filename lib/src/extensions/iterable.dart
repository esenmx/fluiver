part of '../../fluiver.dart';

extension IterableElement<E> on Iterable<E> {
  /// Similar to [Iterable.firstWhere], but does not have [orElse] function and
  /// does not throw [StateError]
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Similar to [Iterable.lastWhere], but does not have [orElse] function and
  /// does not throw [StateError]
  E? lastWhereOrNull(bool Function(E element) test) {
    for (var i = length; i > 0; i--) {
      final e = elementAt(i - 1);
      if (test(e)) {
        return e;
      }
    }
    return null;
  }
}

extension IterableFilter<E> on Iterable<E> {
  /// [!] operator is useless with referential assignment, in that case
  /// use this method.
  /// ```dart
  /// [1, 2, 3].where((e) => !predicate(e)); // Less readable
  /// [1, 2, 3].whereNot(predicate); // More readable
  /// ```
  Iterable<E> whereNot(bool Function(E element) test) {
    return where((element) => !test(element));
  }

  /// Super version of [List.sublist] method
  Iterable<E> subIteration(int start, [int? end]) sync* {
    RangeError.checkValidRange(start, end, length);
    if (start == end) {
      return;
    }
    var i = 0;
    final itr = iterator;
    while (itr.moveNext()) {
      if (i == end) {
        return;
      }
      if (start <= i) {
        yield itr.current;
      }
      i++;
    }
  }
}

extension IterableSeparator<E> on Iterable<E> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere; [Flex], [Scrollable], [InlineSpan]...
  /// ```dart
  /// [Child(), Child()].separate(Divider()) == [Child(), Divider(), Child()]
  /// ```
  Iterable<E> separate(E Function() separator) sync* {
    final itr = iterator;
    if (itr.moveNext()) {
      yield itr.current;
    }
    while (itr.moveNext()) {
      yield separator();
      yield itr.current;
    }
  }
}

extension IterableGroup<E> on Iterable<E> {
  /// Creates a [Map] that has grouped [Iterable] elements as [List] with
  /// specified [classifier] parameter.
  /// Useful for categorizing/grouping [Widget]s when data comes as flat [List]
  Map<K, List<E>> groupAsMap<K>(K Function(E element) classifier) {
    final map = <K, List<E>>{};
    for (final e in this) {
      final key = classifier(e);
      map[key] ??= <E>[];
      map[key]!.add(e);
    }
    return map;
  }
}

extension TwoDimIterable<E> on Iterable<E> {
  /// ```dart
  /// [1].convertTo2D(2) // [[1]]
  /// [1, 2, 3, 4].convertTo2D(2) // [[1, 2], [3, 4]]
  /// [1, 2, 3, 4].convertTo2D(3) // [[1, 2, 3], [4]]
  /// ```
  Iterable<List<E>> to2D(int div) sync* {
    RangeError.checkValueInInterval(div, 1, 1 << 31);
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final subArray = <E>[iterator.current];
      for (int i = 0; i < div - 1; i++) {
        if (iterator.moveNext()) {
          subArray.add(iterator.current);
        } else {
          break;
        }
      }
      yield subArray;
    }
  }
}

extension NestedIterable<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> flatten() sync* {
    for (final sub in this) {
      yield* sub;
    }
  }
}

extension ChronoIterable<E> on Iterable<E> {
  E earliest(DateTime Function(E e) toDateTime) => _first(toDateTime);

  E latest(DateTime Function(E e) toDateTime) => _first(toDateTime, false);

  E _first(DateTime Function(E e) toDateTime, [bool ascending = true]) {
    final itr = iterator;
    if (!itr.moveNext()) {
      throw StateError('no element found in $this');
    }

    E element = itr.current;
    DateTime dateTime = toDateTime(element);

    while (itr.moveNext()) {
      final currentDateTime = toDateTime(itr.current);
      if (ascending) {
        if (currentDateTime.isBefore(dateTime)) {
          element = itr.current;
          dateTime = currentDateTime;
        }
      } else {
        if (currentDateTime.isAfter(dateTime)) {
          element = itr.current;
          dateTime = currentDateTime;
        }
      }
    }
    return element;
  }
}
