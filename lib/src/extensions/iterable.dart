part of '../../fluiver.dart';


/// {@macro extensionFor}
/// Separating [Iterable] elements.
extension IterableSeparator<E> on Iterable<E> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere; [Flex], [Scrollable], [InlineSpan]...
  /// ```dart
  /// [Child(), Child()].separated(Divider()) == [Child(), Divider(), Child()]
  /// ```
  Iterable<E> separated(E Function() separator) sync* {
    final itr = iterator;
    if (itr.moveNext()) {
      yield itr.current;
    }
    while (itr.moveNext()) {
      yield separator();
      yield itr.current;
    }
  }
}
