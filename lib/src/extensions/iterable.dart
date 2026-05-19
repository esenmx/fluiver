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
