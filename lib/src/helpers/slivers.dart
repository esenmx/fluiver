part of fluiver;

class FixedExtentSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  FixedExtentSliverPersistentHeaderDelegate({
    required this.extent,
    required this.builder,
  });

  final double extent;
  final Widget Function(BuildContext context, bool overlapsContent) builder;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return builder(context, overlapsContent);
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(covariant oldDelegate) => false;
}
