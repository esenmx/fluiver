part of fluiver;

class GridColumn<T> extends StatelessWidget {
  const GridColumn({
    super.key,
    required this.items,
    required this.builder,
    this.padding = EdgeInsets.zero,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext context, T value, int index) builder;
  final EdgeInsets padding;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth -
            padding.horizontal -
            (crossAxisCount - 1) * crossAxisSpacing;
        final grid = items.to2D(crossAxisCount);
        final children = <Widget>[];
        for (var i = 0; i < grid.length; i++) {
          final subItems = grid.elementAt(i);
          final row = <Widget>[];
          for (var j = 0; j < subItems.length; j++) {
            row.add(SizedBox.square(
              dimension: width / crossAxisCount,
              child: builder(context, subItems[j], i * crossAxisCount + j),
            ));
          }
          children.add(Row(
            children: row.separate(() {
              return SizedBox(width: crossAxisSpacing);
            }).toList(),
          ));
        }
        return PaddedColumn(
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: children.separate(() {
            return SizedBox(height: mainAxisSpacing);
          }).toList(),
        );
      },
    );
  }
}
