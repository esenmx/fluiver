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
        final gridItems = items.to2D(crossAxisCount);
        final children = <Widget>[];
        for (var i = 0; i < gridItems.length; i++) {
          final subItems = gridItems.elementAt(i);
          final subChildren = <Widget>[];
          for (var j = 0; j < subItems.length; j++) {
            subChildren.add(SizedBox.square(
              dimension: width / crossAxisCount,
              child: builder(context, subItems[j], i * crossAxisCount + j),
            ));
            if (j < subItems.length - 1) {
              subChildren.add(SizedBox(width: crossAxisSpacing));
            }
          }
          children.add(Row(children: subChildren));
          if (i < gridItems.length - 1) {
            children.add(SizedBox(height: mainAxisSpacing));
          }
        }
        return PaddedColumn(
          padding: padding,
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
