part of '../../fluiver.dart';

/// A non-scrolling grid: [GridView]'s layout without its viewport.
///
/// Configured by the same [SliverGridDelegate] family as [GridView], so
/// GridView code translates 1:1 — but this is a plain [RenderBox]: it
/// lays out all children in one O(n) pass, sizes itself to fit, answers
/// intrinsic and dry-layout queries (a shrink-wrapped [GridView] throws
/// on intrinsics), and adds no repaint boundaries, scroll semantics, or
/// keep-alive machinery.
///
/// Use inside a [ListView] / [SingleChildScrollView] / [Column]; use a
/// real [GridView] only when the grid itself scrolls.
///
/// Example:
/// ```dart
/// Grid.count(
///   crossAxisCount: 2,
///   mainAxisSpacing: 8,
///   crossAxisSpacing: 8,
///   children: List.generate(10, (i) => ProductCard(products[i])),
/// )
/// ```
class Grid extends MultiChildRenderObjectWidget {
  /// Creates a non-scrolling grid with a custom [gridDelegate].
  const Grid({
    required this.gridDelegate,
    super.children,
    this.direction = .vertical,
    this.padding = .zero,
    super.key,
  });

  /// A fixed-column grid — mirrors [GridView.count].
  Grid.count({
    required int crossAxisCount,
    super.children,
    double mainAxisSpacing = .0,
    double crossAxisSpacing = .0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    this.direction = .vertical,
    this.padding = .zero,
    super.key,
  }) : gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: crossAxisCount,
         mainAxisSpacing: mainAxisSpacing,
         crossAxisSpacing: crossAxisSpacing,
         childAspectRatio: childAspectRatio,
         mainAxisExtent: mainAxisExtent,
       );

  /// A max-cell-extent responsive grid — mirrors [GridView.extent].
  Grid.extent({
    required double maxCrossAxisExtent,
    super.children,
    double mainAxisSpacing = .0,
    double crossAxisSpacing = .0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    this.direction = .vertical,
    this.padding = .zero,
    super.key,
  }) : gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
         maxCrossAxisExtent: maxCrossAxisExtent,
         mainAxisSpacing: mainAxisSpacing,
         crossAxisSpacing: crossAxisSpacing,
         childAspectRatio: childAspectRatio,
         mainAxisExtent: mainAxisExtent,
       );

  /// Sizing policy — any [SliverGridDelegate], exactly as in [GridView].
  final SliverGridDelegate gridDelegate;

  /// The main axis the grid grows along. Not called `scrollDirection`
  /// because nothing scrolls.
  final Axis direction;

  /// The padding around the grid.
  final EdgeInsetsGeometry padding;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGrid(
      gridDelegate: gridDelegate,
      direction: direction,
      padding: padding,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderGrid renderObject) {
    renderObject
      ..gridDelegate = gridDelegate
      ..direction = direction
      ..padding = padding
      ..textDirection = Directionality.maybeOf(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SliverGridDelegate>('gridDelegate', gridDelegate),
      )
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
  }
}

class _GridParentData extends ContainerBoxParentData<RenderBox> {}

/// Render object backing [Grid].
///
/// Consumes a [SliverGridDelegate] through synthetic [SliverConstraints]
/// (the stock delegates only read `crossAxisExtent` and
/// `crossAxisDirection`), so RTL cross-axis reversal comes from the
/// delegate's own layout, matching [GridView].
class RenderGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GridParentData> {
  /// Creates the [Grid] render object.
  RenderGrid({
    required SliverGridDelegate gridDelegate,
    required Axis direction,
    required EdgeInsetsGeometry padding,
    TextDirection? textDirection,
  }) : _gridDelegate = gridDelegate,
       _direction = direction,
       _padding = padding,
       _textDirection = textDirection;

  /// Sizing policy; relayout follows [SliverGridDelegate.shouldRelayout].
  SliverGridDelegate get gridDelegate => _gridDelegate;
  SliverGridDelegate _gridDelegate;
  set gridDelegate(SliverGridDelegate value) {
    if (identical(_gridDelegate, value)) return;
    if (value.runtimeType != _gridDelegate.runtimeType ||
        value.shouldRelayout(_gridDelegate)) {
      markNeedsLayout();
    }
    _gridDelegate = value;
  }

  /// Grid main-axis direction.
  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  /// Padding around the grid.
  EdgeInsetsGeometry get padding => _padding;
  EdgeInsetsGeometry _padding;
  set padding(EdgeInsetsGeometry value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  /// Ambient text direction; resolves [padding] and reverses the cross
  /// axis of vertical grids, as [GridView] does.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  // EdgeInsets ignores the direction; EdgeInsetsDirectional asserts it is
  // non-null, matching framework render objects.
  EdgeInsets get _resolvedPadding => _padding.resolve(_textDirection);

  bool get _isVertical => _direction == .vertical;

  bool get _isRtl => _textDirection == .rtl;

  double get _crossPaddingSum {
    final p = _resolvedPadding;
    return _isVertical ? p.left + p.right : p.top + p.bottom;
  }

  double get _mainPaddingSum {
    final p = _resolvedPadding;
    return _isVertical ? p.top + p.bottom : p.left + p.right;
  }

  /// Content-area cross extent for a total cross extent (padding
  /// included), clamped so degenerate constraints yield zero, not
  /// negative.
  double _crossContentFor(double crossExtent) =>
      clampDouble(crossExtent - _crossPaddingSum, 0, .infinity);

  SliverGridLayout _layoutFor(double crossContentExtent) {
    return _gridDelegate.getLayout(
      SliverConstraints(
        axisDirection: _isVertical ? .down : .right,
        growthDirection: .forward,
        userScrollDirection: .idle,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: .infinity,
        crossAxisExtent: crossContentExtent,
        crossAxisDirection: _isVertical && _isRtl
            ? .left
            : (_isVertical ? .right : .down),
        viewportMainAxisExtent: .infinity,
        remainingCacheExtent: .infinity,
        cacheOrigin: 0,
      ),
    );
  }

  double _mainContentFor(SliverGridLayout layout) =>
      childCount == 0 ? 0.0 : layout.computeMaxScrollOffset(childCount);

  bool _debugHasBoundedCrossAxis(BoxConstraints constraints) {
    if ((_isVertical ? constraints.maxWidth : constraints.maxHeight).isFinite) {
      return true;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'Grid requires a bounded ${_isVertical ? 'width' : 'height'}.',
      ),
      ErrorDescription(
        'A ${_isVertical ? 'vertical' : 'horizontal'} Grid asks its '
        'gridDelegate to divide the maximum '
        '${_isVertical ? 'width' : 'height'} into cells, which is '
        'impossible under unbounded constraints.',
      ),
      ErrorHint(
        'This typically happens when the grid sits in a '
        '${_isVertical ? 'Row or a horizontal' : 'Column or a vertical'} '
        'scrollable. Give it a bounded '
        '${_isVertical ? 'width' : 'height'} — e.g. via Expanded or '
        'SizedBox.',
      ),
    ]);
  }

  Size _layoutSize(BoxConstraints constraints) {
    final crossMax = _isVertical ? constraints.maxWidth : constraints.maxHeight;
    final layout = _layoutFor(_crossContentFor(crossMax));
    final mainSize = _mainContentFor(layout) + _mainPaddingSum;
    return constraints.constrain(
      _isVertical ? Size(crossMax, mainSize) : Size(mainSize, crossMax),
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(_debugHasBoundedCrossAxis(constraints), 'unbounded cross axis');
    return _layoutSize(constraints);
  }

  @override
  void performLayout() {
    assert(_debugHasBoundedCrossAxis(constraints), 'unbounded cross axis');
    final p = _resolvedPadding;
    final crossMax = _isVertical ? constraints.maxWidth : constraints.maxHeight;
    final layout = _layoutFor(_crossContentFor(crossMax));
    size = _layoutSize(constraints);

    var index = 0;
    var child = firstChild;
    while (child != null) {
      final geometry = layout.getGeometryForChildIndex(index);
      child.layout(
        BoxConstraints.tight(
          _isVertical
              ? Size(geometry.crossAxisExtent, geometry.mainAxisExtent)
              : Size(geometry.mainAxisExtent, geometry.crossAxisExtent),
        ),
      );

      // Vertical RTL is reversed by the delegate's own layout (via
      // crossAxisDirection); horizontal RTL reverses the main axis here,
      // anchored to the trailing edge as GridView's axisDirection flip
      // is, even when the box is forced wider than the content.
      final mainOffset = !_isVertical && _isRtl
          ? size.width -
                p.horizontal -
                geometry.scrollOffset -
                geometry.mainAxisExtent
          : geometry.scrollOffset;

      final parentData = child.parentData! as _GridParentData
        ..offset = _isVertical
            ? Offset(p.left + geometry.crossAxisOffset, p.top + mainOffset)
            : Offset(p.left + mainOffset, p.top + geometry.crossAxisOffset);

      child = parentData.nextSibling;
      index++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToFirstActualBaseline(baseline);

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    assert(_debugHasBoundedCrossAxis(constraints), 'unbounded cross axis');
    final crossMax = _isVertical ? constraints.maxWidth : constraints.maxHeight;
    final layout = _layoutFor(_crossContentFor(crossMax));
    final paddingTop = _resolvedPadding.top;
    var index = 0;
    var child = firstChild;
    while (child != null) {
      final geometry = layout.getGeometryForChildIndex(index);
      final childConstraints = BoxConstraints.tight(
        _isVertical
            ? Size(geometry.crossAxisExtent, geometry.mainAxisExtent)
            : Size(geometry.mainAxisExtent, geometry.crossAxisExtent),
      );
      final childBaseline = child.getDryBaseline(childConstraints, baseline);
      if (childBaseline != null) {
        // Mirrors defaultComputeDistanceToFirstActualBaseline: first child
        // with a baseline wins, offset by its dry grid position.
        final top = _isVertical
            ? geometry.scrollOffset
            : geometry.crossAxisOffset;
        return childBaseline + paddingTop + top;
      }
      child = (child.parentData! as _GridParentData).nextSibling;
      index++;
    }
    return null;
  }

  /// Cross-axis extent (padding included) shrink-wrapping the children's
  /// cross intrinsics. Exact for the fixed-count delegate; other
  /// delegates adapt their cell count to any extent, so the widest
  /// single cell is the honest minimum.
  double _crossIntrinsicFromChildren(double Function(RenderBox child) measure) {
    if (firstChild == null) return _crossPaddingSum;
    var maxChild = 0.0;
    var child = firstChild;
    while (child != null) {
      final extent = measure(child);
      if (extent > maxChild) maxChild = extent;
      child = (child.parentData! as _GridParentData).nextSibling;
    }
    final delegate = _gridDelegate;
    if (delegate is SliverGridDelegateWithFixedCrossAxisCount) {
      return maxChild * delegate.crossAxisCount +
          (delegate.crossAxisCount - 1) * delegate.crossAxisSpacing +
          _crossPaddingSum;
    }
    return maxChild + _crossPaddingSum;
  }

  /// Main-axis extent (padding included) for a total cross extent
  /// (padding included) — closed-form via the delegate for any delegate.
  double _mainIntrinsicForCross(double crossExtent) {
    if (childCount == 0) return _mainPaddingSum;
    final layout = _layoutFor(_crossContentFor(crossExtent));
    return _mainContentFor(layout) + _mainPaddingSum;
  }

  double _unboundedCrossFallback() {
    return _crossIntrinsicFromChildren(
      (child) => _isVertical
          ? child.getMaxIntrinsicWidth(.infinity)
          : child.getMaxIntrinsicHeight(.infinity),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_isVertical) {
      return _crossIntrinsicFromChildren(
        (child) => child.getMinIntrinsicWidth(.infinity),
      );
    }
    return _mainIntrinsicForCross(
      height.isFinite ? height : _unboundedCrossFallback(),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (_isVertical) {
      return _crossIntrinsicFromChildren(
        (child) => child.getMaxIntrinsicWidth(.infinity),
      );
    }
    return _mainIntrinsicForCross(
      height.isFinite ? height : _unboundedCrossFallback(),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (_isVertical) {
      return _mainIntrinsicForCross(
        width.isFinite ? width : _unboundedCrossFallback(),
      );
    }
    return _crossIntrinsicFromChildren(
      (child) => child.getMinIntrinsicHeight(.infinity),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (_isVertical) {
      return _mainIntrinsicForCross(
        width.isFinite ? width : _unboundedCrossFallback(),
      );
    }
    return _crossIntrinsicFromChildren(
      (child) => child.getMaxIntrinsicHeight(.infinity),
    );
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GridParentData) {
      child.parentData = _GridParentData();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SliverGridDelegate>('gridDelegate', gridDelegate),
      )
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(
        EnumProperty<TextDirection>(
          'textDirection',
          textDirection,
          defaultValue: null,
        ),
      );
  }
}
