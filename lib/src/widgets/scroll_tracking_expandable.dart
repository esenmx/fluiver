part of '../../fluiver.dart';

/// A widget that conditionally expands or collapses its [child] and
/// automatically tracks its bottom edge during expansion to ensure it stays
/// visible within the nearest [Scrollable].
class ScrollTrackingExpandable extends StatefulWidget {
  /// Creates a [ScrollTrackingExpandable].
  const ScrollTrackingExpandable({
    required this.isExpanded,
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOutCubic,
    this.scrollOffset = 0.0,
  });

  /// Whether the widget should be expanded.
  final bool isExpanded;

  /// The widget to show or hide.
  final Widget child;

  /// The duration of the expansion/collapse animation.
  final Duration duration;

  /// The curve of the expansion/collapse animation.
  final Curve curve;

  /// Extra scroll offset to track below the widget (e.g. for breathing room).
  final double scrollOffset;

  @override
  State<ScrollTrackingExpandable> createState() =>
      _ScrollTrackingExpandableState();
}

class _ScrollTrackingExpandableState extends State<ScrollTrackingExpandable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _controller.addListener(_trackScroll);
    _updateAnimation();
  }

  void _updateAnimation() {
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(covariant ScrollTrackingExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _animation.dispose();
      _updateAnimation();
    }
    if (widget.isExpanded != oldWidget.isExpanded) {
      final _ = widget.isExpanded
          ? _controller.forward()
          : _controller.reverse();
    }
  }

  void _trackScroll() {
    // RenderBox.size lags the tick by one frame (ticks run before layout),
    // and the last tick fires with status already completed — defer to
    // post-frame and include completed so the fully expanded extent is
    // revealed.
    if (mounted && _isExpanding) {
      WidgetsBinding.instance.addPostFrameCallback(_showOnScreen);
    }
  }

  bool get _isExpanding => switch (_controller.status) {
    .forward || .completed => true,
    .reverse || .dismissed => false,
  };

  void _showOnScreen(Duration _) {
    if (!mounted || !_isExpanding) return;
    if (context.findRenderObject() case final RenderBox rb) {
      rb.showOnScreen(
        rect: Rect.fromLTWH(
          0,
          0,
          rb.size.width,
          rb.size.height + widget.scrollOffset,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller
      ..removeListener(_trackScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizeTransition(sizeFactor: _animation, child: widget.child),
    );
  }
}
