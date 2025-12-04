part of '../../fluiver.dart';

/// A [SliverPersistentHeaderDelegate] with fixed extent.
class FixedExtentSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  FixedExtentSliverPersistentHeaderDelegate({
    required this.extent,
    required this.builder,
  });

  final double extent;
  final Widget Function(
    BuildContext context, {
    required bool overlapsContent,
  }) builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, overlapsContent: overlapsContent);
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
