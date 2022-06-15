part of fluiver;

extension IterableX<E> on Iterable<E> {
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

  /// Creates a [Map] that has groupped [Iterable] elements as [List] with
  /// specified [groupper] parameter.
  /// Useful for categorizing/groupping [Widget]s when data comes as flat [List]
  Map<K, List<E>> groupAsMap<K>(K Function(E element) groupper) {
    final map = <K, List<E>>{};
    for (var e in this) {
      final key = groupper(e);
      map[key] ??= <E>[];
      map[key]!.add(e);
    }
    return map;
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
}

extension IterableIterableX<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> from2D() sync* {
    for (final sub in this) {
      yield* sub;
    }
  }
}

typedef ElementToDateTime<E> = DateTime Function(E e);

extension ChronoIterableX<E> on Iterable<E> {
  E earliest(ElementToDateTime<E> toDateTime) => _first(toDateTime, true);

  E latest(ElementToDateTime<E> toDateTime) => _first(toDateTime, false);

  E _first(ElementToDateTime<E> toDateTime, [bool ascending = true]) {
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
