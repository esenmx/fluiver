part of fluiver;

/// Works well with [NestedScrollView]
/// Constructs a [Stack] that behaves like [Column]
/// My usualy usecase is collapsing [AppBar]s with [SliverPersistentHeaderDelegate]s
/// where centering the middle and transforming into collapsed title needed
class StaggeredStack extends StatelessWidget {
  StaggeredStack({
    Key? key,
    required this.children,
    this.background,
    this.defaultHeight,
    this.defaultGap,
    this.topOffset = 0,
  })  : assert(children.every((e) =>
            (e.height != null || defaultHeight != null) &&
            (e.gap != null || defaultGap != null))),
        super(key: key);

  final Iterable<StaggeredStackChild> children;
  final Widget? background;
  final double? defaultHeight;
  final double? defaultGap;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    final c = <Positioned>[];
    for (var i = 0; i < children.length; i++) {
      final e = children.elementAt(i);
      final top = children.take(i).fold<double>(0, (pv, e) {
        return pv + (e.gap ?? defaultGap!) + (e.height ?? defaultHeight!);
      });
      c.add(Positioned(
        child: e.child,
        height: e.height ?? defaultHeight,
        top: topOffset + top,
      ));
    }
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      fit: StackFit.expand,
      children: [if (background != null) background!, ...c],
    );
  }
}

class StaggeredStackChild {
  StaggeredStackChild({required this.child, this.height, this.gap});

  final Widget child;
  final double? height;
  final double? gap;
}
