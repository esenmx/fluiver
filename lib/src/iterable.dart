part of dashx;

extension IterableExtensions<E> on Iterable<E> {
  /// [1, 2, 3, 4, 5, 6].convertTo2D(2) == [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3, 4].convertTo2D(3) == [[1, 2, 3], [4]]
  Iterable<List<E>> to2D(int div) sync* {
    RangeError.range(div, 1, 1 << 31);
    for (int i = 0; i < length; i += div) {
      yield skip(i).take(div).toList();
    }
  }

  Map<int, E> get toIndexedMap {
    if (isEmpty) {
      return <int, E>{};
    }
    final iterator = this.iterator;
    final map = <int, E>{};
    int i = 0;
    while (iterator.moveNext()) {
      map[i++] = iterator.current;
    }
    return map;
  }
}

extension Iterable2DExtensions<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> get from2D sync* {
    for (final sub in this) {
      yield* sub;
    }
  }
}

typedef IndexedChildBuilder = Widget Function(Widget child, int index);

extension IterableWidgetExtensions on Iterable<Widget> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere, possibly [Column], [Row], [Listview]...
  /// [Dash(), Dash()].widgetJoin(Divider()) == [Dash(), Divider(), Dash()]
  Iterable<Widget> widgetJoin(Widget separator) sync* {
    final Iterator<Widget> iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
    }
    while (iterator.moveNext()) {
      yield separator;
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

extension WidgetIterableExtensions<E> on Iterable<E> {
  /// Useful for widgets like [CupertinoSegmentedControl]
  /// ['Foo', 'Bar', 'Baz'].mappedChildren((e) => Text(e))
  /// returns:
  /// {
  ///   'Foo' : Text('Foo'),
  ///   'Foo' : Text('Bar'),
  ///   'Foo' : Text('Baz'),
  /// }
  /// CupertinoSegmentedControl(
  ///   ...
  ///   children: children.mappedChildren
  ///   ...
  /// );
  Map<E, Widget> mappedChildren(Widget Function(E element) builder) =>
      {for (int i = 0; i < length; i++) elementAt(i): builder(elementAt(i))};
}
