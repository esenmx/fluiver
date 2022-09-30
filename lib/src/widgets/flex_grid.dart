part of fluiver;

class FlexGrid<T> extends StatelessWidget {
  const FlexGrid({
    super.key,
    required this.items,
    required this.builder,
    this.direction = Axis.vertical,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext context, T value, int index) builder;
  final Axis direction;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    final crossGap = direction == Axis.vertical
        ? SizedBox(width: crossAxisSpacing)
        : SizedBox(height: crossAxisSpacing);
    final mainGap = direction == Axis.vertical
        ? SizedBox(height: mainAxisSpacing)
        : SizedBox(width: mainAxisSpacing);
    final crossAxis =
        direction == Axis.vertical ? Axis.horizontal : Axis.vertical;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing;
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
              subChildren.add(crossGap);
            }
          }
          children.add(Flex(direction: crossAxis, children: subChildren));
          if (i < gridItems.length - 1) {
            children.add(mainGap);
          }
        }
        return Flex(
          direction: direction,
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
