part of '../../fluiver.dart';

/// Using nested [ScrollView]s is not recommended(see [ScrollView.shrinkWrap])
/// Alternative of [ListView] is [Column] but there isn't any for [GridView]
/// FlexGrid solves this by using simple [Wrap].
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
    required this.children,
    required this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.mainAxisExtent = 0,
    this.direction = Axis.vertical,
  })  : assert(crossAxisCount > 1),
        assert(childAspectRatio >= 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing > 0);

  final List<Widget> children;

  /// Same as [SliverGridDelegateWithFixedCrossAxisCount.crossAxisCount]
  final int crossAxisCount;

  /// Same as [SliverGridDelegateWithFixedCrossAxisCount.childAspectRatio]
  final double childAspectRatio;

  /// Same as [SliverGridDelegateWithFixedCrossAxisCount.mainAxisSpacing]
  final double mainAxisSpacing;

  /// Same as [SliverGridDelegateWithFixedCrossAxisCount.crossAxisSpacing]
  final double crossAxisSpacing;

  /// Similar to [SliverGridDelegateWithFixedCrossAxisCount.mainAxisExtent] but
  /// with a big difference, unlike [SliverGridDelegateWithFixedCrossAxisCount],
  /// both [mainAxisExtent] and [childAspectRatio] used in calculation regardless
  /// off their value.
  final double mainAxisExtent;

  /// Same as [Flex.direction]
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalCrossAxisExtent = (direction.isVertical
                ? constraints.maxWidth
                : constraints.maxHeight) -
            (crossAxisCount - 1) * crossAxisSpacing;

        final childCrossAxisExtent = totalCrossAxisExtent / crossAxisCount;
        final itemMainAxisExtent =
            childCrossAxisExtent / childAspectRatio + mainAxisExtent;

        final size = Size(
          direction.isVertical ? childCrossAxisExtent : itemMainAxisExtent,
          direction.isHorizontal ? childCrossAxisExtent : itemMainAxisExtent,
        );
        return Wrap(
          spacing: crossAxisSpacing,
          runSpacing: mainAxisSpacing,
          direction: direction.reverse,
          children: children
              .map((e) => SizedBox.fromSize(size: size, child: e))
              .toList(),
        );
      },
    );
  }
}
