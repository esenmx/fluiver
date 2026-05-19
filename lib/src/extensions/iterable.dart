part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Separating [Iterable] elements.
extension IterableSeparator<E> on Iterable<E> {
  /// Yields each element of this iterable separated by the result of
  /// [separator]. More versatile than [ListTile.divideTiles] — works
  /// anywhere ([Flex], [Scrollable], `InlineSpan`, …).
  ///
  /// ```dart
  /// [Child(), Child()].separated((_) => Divider())
  /// // → [Child(), Divider(), Child()]
  /// ```
  ///
  /// The argument to [separator] is the separator index (0 between the
  /// first two elements, 1 between the next, …), not the element index.
  Iterable<E> separated(E Function(int index) separator) sync* {
    final itr = iterator;
    if (itr.moveNext()) {
      yield itr.current;
    }
    var i = 0;
    while (itr.moveNext()) {
      yield separator(i);
      yield itr.current;
      i++;
    }
  }
}

/// {@macro extensionFor}
/// Stepped sliding-window iteration over an [Iterable].
///
/// Fills a gap left by `package:collection` — its `slices` only yields
/// non-overlapping chunks, with no step parameter. Named after Kotlin's
/// `windowed` for cross-language familiarity.
extension IterableWindowed<E> on Iterable<E> {
  /// Yields fixed-[size] windows, advancing by [step] each time.
  ///
  /// - [size] must be `> 0`.
  /// - [step] must be `> 0`. Defaults to `1` (every overlapping window).
  /// - Partial trailing windows (fewer than [size] elements) are
  ///   dropped — matches Kotlin's default `partialWindows: false`.
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].windowed(3);            // ([1,2,3], [2,3,4], [3,4,5])
  /// [1, 2, 3, 4, 5].windowed(2, step: 2);   // ([1,2], [3,4])
  /// [1, 2].windowed(3);                     // () — size > length
  /// ```
  Iterable<List<E>> windowed(int size, {int step = 1}) sync* {
    RangeError.checkNotNegative(size - 1, 'size');
    RangeError.checkNotNegative(step - 1, 'step');

    final buffer = <E>[];
    var skip = 0;
    for (final element in this) {
      if (skip > 0) {
        skip--;
        continue;
      }
      buffer.add(element);
      if (buffer.length == size) {
        yield List<E>.unmodifiable(buffer);
        if (step >= size) {
          buffer.clear();
          skip = step - size;
        } else {
          buffer.removeRange(0, step);
        }
      }
    }
  }
}
