part of fluiver;

extension IterableWidgetX on Iterable<Widget> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere, possibly [Column], [Row], [ListView]...
  /// ```dart
  /// [Child(), Child()].widgetJoin(Divider()) == [Child(), Divider(), Child()]
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
}

extension WidgetIterableX<E> on Iterable<E> {
  /// Similar to [groupAsMap] but instead of grouping, it synchronously
  /// generates header [Slice\S] widgets.
  Iterable<Widget> slicedWidgetBuilder<S extends Object>({
    required BuildContext context,
    required ValueWidgetBuilder<E> widgetBuilder,
    required S? Function(E) toSlicer,
    required Widget Function(BuildContext context, S? slicer) slicerBuilder,
    WidgetBuilder? separatorBuilder,
    Widget? child,
  }) sync* {
    final iter = iterator;
    Object? last = Object();
    bool consecutive = false;
    while (iter.moveNext()) {
      final slicer = toSlicer(iter.current);
      if (slicer != last) {
        yield slicerBuilder(context, slicer);
        last = slicer;
        consecutive = false;
      } else {
        if (consecutive && separatorBuilder != null) {
          yield separatorBuilder(context);
        }
      }
      yield widgetBuilder(context, iter.current, child);
      consecutive = true;
    }
  }
}
