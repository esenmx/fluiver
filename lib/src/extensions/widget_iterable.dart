part of fluiver;

extension WidgetIterableX<E> on Iterable<E> {
  /// Lazy way to generate widgets that groups via specific field.
  /// Similar to [groupAsMap] but instead of grouping, it synchronously
  /// generates widgets.
  ///
  /// If resource is sorted, use this method. If it's not sorted and needs to be,
  /// then use [groupAsMap] to generate widgets.
  ///
  /// Typical example would be separating [ListTile] with [DateTime] or
  /// [TimeOfDay] titles.
  ///
  /// By using [DateTimeX.toDate()] or [DateTimeX.toTime()] extension
  /// method(included with this package), you can truncate time values.
  Iterable<Widget> slicedWidgetBuilder<S extends Object>({
    required BuildContext context,
    required ValueWidgetBuilder<E> widgetBuilder,
    required S? Function(E element) toSlicer,
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
