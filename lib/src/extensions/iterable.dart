part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Separating [Iterable] elements.
extension IterableSeparator<E> on Iterable<E> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere; [Flex], [Scrollable], [InlineSpan]...
  /// ```dart
  /// [Child(), Child()].separated(Divider()) == [Child(), Divider(), Child()]
  ///
  /// [index] refers to [separator] index, not element index.
  /// ```
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
