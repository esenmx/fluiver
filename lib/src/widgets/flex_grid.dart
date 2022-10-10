part of fluiver;

/// Using nested [ScrollView]s is not recommended(see [ScrollView.shrinkWrap])
/// Alternative of [ListView] is [Column] but there isn't for [GridView]
/// FlexGrid solves this, by combining [Flex]es.
///
/// Example: ```dart
/// Padding(
///   padding: const EdgeInsets.all(8.0),
///   child: FlexGrid<int>(
///     crossAxisCount: 2,
///     mainAxisSpacing: 8,
///     crossAxisSpacing: 8,
///     childAspectRatio: .8,
///     mainAxisExtent: 16,
///     items: List.generate(10, (index) => index),
///     builder: (context, value, index) {
///       return Material(
///         color: Colors.primaries[value % Colors.primaries.length],
///       );
///     },
///   ),
/// ),
/// ```
class FlexGrid<T> extends StatelessWidget {
  const FlexGrid({
    super.key,
    this.direction = Axis.vertical,
    required this.items,
    required this.builder,
    required this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.mainAxisExtent = 0,
  })  : assert(crossAxisCount > 1),
        assert(childAspectRatio >= 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing > 0);

  /// Vertical for [Column], Horizontal for [Row]
  final Axis direction;
  final Iterable<T> items;
  final Widget Function(BuildContext context, T value, int index) builder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    final crossGap = direction == Axis.vertical
        ? SizedBox(width: crossAxisSpacing)
        : SizedBox(height: crossAxisSpacing);
    final mainGap = direction == Axis.vertical
        ? SizedBox(height: mainAxisSpacing)
        : SizedBox(width: mainAxisSpacing);

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisSpace = (direction.isVertical
                ? constraints.maxWidth
                : constraints.maxHeight) -
            (crossAxisCount - 1) * crossAxisSpacing;

        final itemCrossAxisSpace = crossAxisSpace / crossAxisCount;
        final itemMainAxisSpace =
            itemCrossAxisSpace / childAspectRatio + mainAxisExtent;
        final size = Size(
          direction.isVertical ? itemCrossAxisSpace : itemMainAxisSpace,
          direction.isHorizontal ? itemCrossAxisSpace : itemMainAxisSpace,
        );

        final gridItems = items.to2D(crossAxisCount);
        final children = <Widget>[];
        for (var i = 0; i < gridItems.length; i++) {
          final subItems = gridItems.elementAt(i);
          final subChildren = <Widget>[];
          for (var j = 0; j < subItems.length; j++) {
            subChildren.add(SizedBox.fromSize(
              size: size,
              child: builder(context, subItems[j], i * crossAxisCount + j),
            ));
            if (j < subItems.length - 1) {
              subChildren.add(crossGap);
            }
          }
          children.add(Flex(
            direction: direction.reverse,
            children: subChildren,
          ));
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
