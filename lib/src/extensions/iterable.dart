part of fluiver;

extension IterableX<E> on Iterable<E> {
  /// ```dart
  /// [1].convertTo2D(2) // [[1]]
  /// [1, 2, 3, 4].convertTo2D(2) // [[1, 2], [3, 4]]
  /// [1, 2, 3, 4].convertTo2D(3) // [[1, 2, 3], [4]]
  /// ```
  Iterable<List<E>> to2D(int div) sync* {
    RangeError.range(div, 1, 1 << 31);
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

  Map<int, E> toIndexedMap([int offset = 0]) {
    if (isEmpty) {
      return <int, E>{};
    }
    final iterator = this.iterator;
    final map = <int, E>{};
    int i = offset;
    while (iterator.moveNext()) {
      map[i++] = iterator.current;
    }
    return map;
  }

  /// Useful for widgets like [CupertinoSegmentedControl]
  /// ```dart
  /// ['Foo', 'Bar', 'Baz'].mappedChildren((e) => Text(e))
  /// returns:
  /// {
  ///   'Foo' : Text('Foo'),
  ///   'Foo' : Text('Bar'),
  ///   'Foo' : Text('Baz'),
  /// }
  /// ```
  /// ```dart
  /// CupertinoSegmentedControl(
  ///   ...
  ///   children: children.mappedChildren
  ///   ...
  /// );
  /// ```
  Map<E, Widget> mappedChildren(Widget Function(E element) builder) =>
      {for (int i = 0; i < length; i++) elementAt(i): builder(elementAt(i))};
}

extension TwoDIterableX<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> from2D() sync* {
    for (final sub in this) {
      yield* sub;
    }
  }
}

typedef IndexedChildBuilder = Widget Function(Widget child, int index);

extension WidgetIterableX on Iterable<Widget> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere, possibly [Column], [Row], [Listview]...
  /// ```dart
  /// [Dash(), Dash()].widgetJoin(Divider()) == [Dash(), Divider(), Dash()]
  /// ```
  Iterable<Widget> widgetJoin(Widget Function() separator) sync* {
    final Iterator<Widget> iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
    }
    while (iterator.moveNext()) {
      yield separator();
      yield iterator.current;
    }
  }

  /// For wrapping each child with an index based builder within possibly a
  /// [Scrollable], instead defining exception for specific index
  Iterable<Widget> staggeredBuild(IndexedChildBuilder builder) sync* {
    for (int i = 0; i < length; i++) {
      yield builder(elementAt(i), i);
    }
  }
}

typedef _ToDateTimeIter<E> = DateTime Function(E e);

extension ChronoIterableX<E> on Iterable<E> {
  E earliest(_ToDateTimeIter<E> toDateTime) => _first(toDateTime, true);

  E latest(_ToDateTimeIter<E> toDateTime) => _first(toDateTime, false);

  E _first(_ToDateTimeIter<E> toDateTime, [bool ascending = true]) {
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
