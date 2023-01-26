part of fluiver;

extension IterableX<E> on Iterable<E> {
  /// Similar to [elementAt] but returns [null] instead of throwing [IndexError]
  E? elementAtOrNull(int index) {
    if (index < length) {
      return elementAt(index);
    }
    return null;
  }

  /// Same as [single] but does not throw [StateError], instead returns null
  E? get singleOrNull => length == 1 ? single : null;

  /// Similar to [Iterable.firstWhere], but does not have [orElse] function and
  /// does not throw [StateError]
  E? firstWhereOrNull(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// [!] operator is useless with referential assignment, in that case
  /// use this method.
  /// ```dart
  /// [1, 2, 3].where((e) => !predicate(e)); // Less readable
  /// [1, 2, 3].whereNot(predicate); // More readable
  /// ```
  Iterable<E> whereNot(bool Function(E element) test) {
    return where((element) => !test(element));
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

  /// Super version of [List.sublist] method
  Iterable<E> subIteration(int start, [int? end]) sync* {
    RangeError.checkValidRange(start, end, length);
    if (start == end) {
      return;
    }
    var i = 0;
    final iter = iterator;
    while (iter.moveNext()) {
      if (i == end) {
        return;
      }
      if (start <= i) {
        yield iter.current;
      }
      i++;
    }
  }

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

  /// Creates a [Map] that has grouped [Iterable] elements as [List] with
  /// specified [classifier] parameter.
  /// Useful for categorizing/grouping [Widget]s when data comes as flat [List]
  Map<K, List<E>> groupAsMap<K>(K Function(E element) classifier) {
    final map = <K, List<E>>{};
    for (var e in this) {
      final key = classifier(e);
      map[key] ??= <E>[];
      map[key]!.add(e);
    }
    return map;
  }

  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere; [Flex], [Scrollable], [InlineSpan]...
  /// ```dart
  /// [Child(), Child()].widgetJoin(Divider()) == [Child(), Divider(), Child()]
  /// ```
  Iterable<E> separate(E Function() separator) sync* {
    final iter = iterator;
    if (iter.moveNext()) {
      yield iter.current;
    }
    while (iter.moveNext()) {
      yield separator();
      yield iter.current;
    }
  }
}

extension IterableIterableX<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> flatten() sync* {
    for (final sub in this) {
      yield* sub;
    }
  }
}

extension ChronoIterableX<E> on Iterable<E> {
  E earliest(DateTime Function(E e) toDateTime) => _first(toDateTime, true);

  E latest(DateTime Function(E e) toDateTime) => _first(toDateTime, false);

  E _first(DateTime Function(E e) toDateTime, [bool ascending = true]) {
    final iter = iterator;
    if (!iter.moveNext()) {
      throw StateError('no element found in $this');
    }

    E element = iter.current;
    DateTime dateTime = toDateTime(element);

    while (iter.moveNext()) {
      final currentDateTime = toDateTime(iter.current);
      if (ascending) {
        if (currentDateTime.isBefore(dateTime)) {
          element = iter.current;
          dateTime = currentDateTime;
        }
      } else {
        if (currentDateTime.isAfter(dateTime)) {
          element = iter.current;
          dateTime = currentDateTime;
        }
      }
    }
    return element;
  }
}
