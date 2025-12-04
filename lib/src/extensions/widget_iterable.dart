part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Building widgets from [Iterable] with slicing/grouping.
extension WidgetIterable<E> on Iterable<E> {
  /// Lazily generates widgets grouped by a selector function.
  ///
  /// Unlike [groupAsMap], this synchronously yields widgets during iteration,
  /// making it ideal for pre-sorted data. For unsorted data that needs
  /// grouping, use [groupAsMap] instead.
  ///
  /// **Example:** Separating [ListTile]s with date headers:
  /// ```dart
  /// entities.slicedWidgetsBuilder<DateTime>(
  ///   context: context,
  ///   toSlicer: (e) => e.dateTime?.toDate(),
  ///   slicerBuilder: (ctx, date) => DateHeader(date),
  ///   valueWidgetBuilder: (ctx, entity, _) => EntityTile(entity),
  ///   separatorBuilder: (ctx) => const Divider(),
  /// )
  /// ```
  ///
  /// Use [DateTimeX.toDate] or [DateTimeX.toTime] to truncate time values.
  Iterable<Widget> slicedWidgetsBuilder<S extends Object>({
    required BuildContext context,

    /// Extracts the grouping key from each element.
    required S? Function(E element) toSlicer,

    /// Builds the header widget for each new group.
    required Widget Function(BuildContext context, S? slicer) slicerBuilder,

    /// Builds the widget for each element.
    required ValueWidgetBuilder<E> valueWidgetBuilder,

    /// Optional separator between consecutive items within the same group.
    WidgetBuilder? separatorBuilder,

    /// Passed to [valueWidgetBuilder] as its child parameter.
    Widget? child,
  }) sync* {
    // Sentinel value that won't match any real slicer value
    Object? previousSlicer = Object();
    var hasItemInCurrentGroup = false;

    for (final element in this) {
      final currentSlicer = toSlicer(element);
      final isNewGroup = currentSlicer != previousSlicer;

      if (isNewGroup) {
        yield slicerBuilder(context, currentSlicer);
        previousSlicer = currentSlicer;
        hasItemInCurrentGroup = false;
      } else if (hasItemInCurrentGroup && separatorBuilder != null) {
        yield separatorBuilder(context);
      }

      yield valueWidgetBuilder(context, element, child);
      hasItemInCurrentGroup = true;
    }
  }
}
