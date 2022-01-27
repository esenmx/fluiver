import 'package:flutter/cupertino.dart';

extension IterableExtensions<T> on Iterable<T> {
  /// [1, 2, 3, 4, 5, 6].convert2D(2) = [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3, 4].convert2D(3) = [[1, 2, 3], [4]]
  List<Iterable<T>> convertTo2D(int div) =>
      <Iterable<T>>[take(div), if (length > div) ...skip(div).convertTo2D(div)];
}

extension DimensionalIterableExtensions<T> on Iterable<Iterable<T>> {
  /// More straightforward solution than [expand] in case of all sub-elements
  /// have same type
  Iterable<T> get flatten2D sync* {
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
