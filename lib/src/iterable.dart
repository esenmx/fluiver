part of dashx;

extension IterableExtensions<E> on Iterable<E> {
  /// [1, 2, 3, 4, 5, 6].convertTo2D(2) = [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3, 4].convertTo2D(3) = [[1, 2, 3], [4]]
  List<Iterable<E>> convertTo2D(int div) => isEmpty
      ? <Iterable<E>>[]
      : <Iterable<E>>[
          take(div),
          if (length > div) ...skip(div).convertTo2D(div)
        ];
}

extension Iterable2DExtensions<E> on Iterable<Iterable<E>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<E> get expand2D sync* {
    for (final current in this) {
      yield* current;
    }
  }
}

typedef StaggeredWidgetBuilder = Widget Function(Widget child, int index);

extension IterableWidgetExtensions on Iterable<Widget> {
  /// Similar to [ListView.separated]'s separatedBuilder,
  /// but you can use it in anywhere like [Column], [Row], [Listview]...
  /// [Dash(), Dash(), Dash()].widgetJoin(Divider()) =>
  /// [Dash(), Divider(), Dash(), Divider(), Dash()]
  /* tearing apart the dashes is not something humankind should do*/
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
  Iterable<Widget> staggeredBuild(StaggeredWidgetBuilder builder) sync* {
    for (int i = 0; i < length; i++) {
      yield builder(elementAt(i), i);
    }
  }

  /// Useful for widgets like [CupertinoSegmentedControl]
  /// [Text('Foo'), Text('Bar'), Text('Baz')].mappedChildren =>
  /// {
  ///   0 : Text('Foo'),
  ///   1 : Text('Bar'),
  ///   2 : Text('Baz'),
  /// }
  /// CupertinoSegmentedControl(
  ///   ...
  ///   children: children.mappedChildren
  ///   ...
  /// );
  Map<int, Widget> get mappedChildren =>
      {for (int i = 0; i < length; i++) i: elementAt(i)};
}
