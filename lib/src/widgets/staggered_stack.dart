part of fluiver;

/// Works well with [NestedScrollView]
/// Constructs a [Stack] that behaves like [Column]
/// My usual usecase is collapsing [AppBar] with [SliverPersistentHeaderDelegate]
/// where centering the middle and transforming into compressed title needed
class StaggeredStack extends StatelessWidget {
  StaggeredStack({
    Key? key,
    required this.children,
    this.background,
    this.defaultHeight,
    this.defaultWidth,
    this.defaultGap,
    this.topOffset = 0,

    /// Stack parameters
    this.alignment = Alignment.center,
    this.fit = StackFit.loose,
    this.clipBehaviour = Clip.hardEdge,
  })  : assert(children.every((e) =>
            (e.height != null || defaultHeight != null) &&
            (e.bottomPadding != null || defaultGap != null) &&
            (e.width != null || defaultWidth != null))),
        super(key: key);

  final Iterable<StaggeredStackChild> children;
  final Widget? background;
  final double? defaultWidth;
  final double? defaultHeight;
  final double? defaultGap;
  final double topOffset;

  /// Stack parameters
  final Alignment alignment;
  final StackFit fit;
  final Clip clipBehaviour;

  @override
  Widget build(BuildContext context) {
    final c = <Positioned>[];
    for (var i = 0; i < children.length; i++) {
      final e = children.elementAt(i);
      final top = children.take(i).fold<double>(0, (pv, e) {
        return pv +
            (e.bottomPadding ?? defaultGap!) +
            (e.height ?? defaultHeight!);
      });
      c.add(Positioned(
        height: e.height ?? defaultHeight,
        width: e.width ?? defaultWidth,
        top: topOffset + top,
        child: e.child,
      ));
    }
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehaviour,
      children: [if (background != null) background!, ...c],
    );
  }
}

class StaggeredStackChild {
  StaggeredStackChild({
    required this.child,
    this.width,
    this.height,
    this.bottomPadding,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double? bottomPadding;
}
