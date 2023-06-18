part of fluiver;

extension WidgetIterable<E> on Iterable<E> {
  /// Lazy way to generate widgets that groups/separates via specific getter.
  /// Similar to [groupAsMap] but instead of grouping, it synchronously
  /// generates widgets.
  ///
  /// If resource is sorted, use this method. If it's not sorted and needs to be,
  /// then use [groupAsMap] to generate widgets.
  ///
  /// Typical example would be separating [ListTile]s with
  /// [DateTime]/[TimeOfDay] tiles.
  ///
  /// By using [DateTimeX.toDate()] or [DateTimeX.toTime()] extension
  /// method(included with this package), you can truncate time values.
  Iterable<Widget> slicedWidgetsBuilder<S extends Object>({
    required BuildContext context,

    /// Think about [Iterable] of this model:
    /// ```dart
    /// class Entity {
    ///   // other fields ...
    ///   // final DateTime? dateTime;
    /// }
    /// ```
    ///
    /// Typical [valueWidgetBuilder]:
    /// Widget valueWidgetBuilder<Entity>(Entity entity) => EntityWidget(entity)
    required ValueWidgetBuilder<E> valueWidgetBuilder,

    /// [toSlicer] will select the getter from the entity.
    /// Let's say we want to separate elements by their date:
    /// ```dart
    /// DateTime? toSlicer(Entity entity) => entity.dateTime?.truncateTime();
    /// ```
    required S? Function(E element) toSlicer,

    /// Builder for the value that selected by [toSlicer] and put between
    /// where separation begins in iteration.
    /// In our case, example would be:
    /// ```dart
    /// Widget slicerBuilder(context, DateTime? date) => DateTile(date)
    /// ```
    required Widget Function(BuildContext context, S? slicer) slicerBuilder,

    /// A divider if there is no [slicer]
    WidgetBuilder? separatorBuilder,

    /// Same as child parameter of [ValueWidgetBuilder<T>]
    Widget? child,
  }) sync* {
    final itr = iterator;
    Object? last = Object();
    bool isConsecutive = false;
    while (itr.moveNext()) {
      final slicer = toSlicer(itr.current);
      if (slicer != last) {
        yield slicerBuilder(context, slicer);
        last = slicer;
        isConsecutive = false;
      } else {
        if (isConsecutive && separatorBuilder != null) {
          yield separatorBuilder(context);
        }
      }
      yield valueWidgetBuilder(context, itr.current, child);
      isConsecutive = true;
    }
  }
}
