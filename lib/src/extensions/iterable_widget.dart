part of fluiver;

extension WidgetIterableX on Iterable<Widget> {
  /// More versatile version of [ListTile.divideTiles],
  /// but you can use it in anywhere, possibly [Column], [Row], [Listview]...
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
