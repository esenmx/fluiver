part of '../../fluiver.dart';

/// A non-scrolling grid layout widget using custom render object.
///
/// Unlike [GridView], this widget doesn't scroll and sizes itself to fit
/// all children. Useful as an alternative to nested [ScrollView]s.
///
/// Example:
/// ```dart
/// FlexGrid(
///   crossAxisCount: 2,
///   mainAxisSpacing: 8,
///   crossAxisSpacing: 8,
///   childAspectRatio: 0.8,
///   padding: EdgeInsets.all(16),
///   children: List.generate(10, (i) => ColoredBox(color: Colors.blue)),
/// )
/// ```
class FlexGrid extends MultiChildRenderObjectWidget {
  const FlexGrid({
    required this.crossAxisCount,
    super.key,
    super.children,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.mainAxisExtent = 0.0,
    this.direction = Axis.vertical,
    this.padding = EdgeInsets.zero,
  })  : assert(crossAxisCount > 0, 'crossAxisCount must be greater than 0'),
        assert(childAspectRatio > 0, 'childAspectRatio must be greater than 0'),
        assert(mainAxisSpacing >= 0, 'mainAxisSpacing must be 0 or positive'),
        assert(crossAxisSpacing >= 0, 'crossAxisSpacing must be 0 or positive'),
        assert(mainAxisExtent >= 0, 'mainAxisExtent must be 0 or positive');

  /// The number of columns in the grid.
  final int crossAxisCount;

  /// The aspect ratio of the children.
  final double childAspectRatio;

  /// The spacing between the children in the main axis.
  final double mainAxisSpacing;

  /// The spacing between the children in the cross axis.
  final double crossAxisSpacing;

  /// The extent of the children in the main axis.
  final double mainAxisExtent;

  /// The direction of the grid.
  final Axis direction;

  /// The padding of the grid.
  final EdgeInsetsGeometry padding;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFlexGrid(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisExtent: mainAxisExtent,
      direction: direction,
      padding: padding,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFlexGrid renderObject) {
    renderObject
      ..crossAxisCount = crossAxisCount
      ..childAspectRatio = childAspectRatio
      ..mainAxisSpacing = mainAxisSpacing
      ..crossAxisSpacing = crossAxisSpacing
      ..mainAxisExtent = mainAxisExtent
      ..direction = direction
      ..padding = padding
      ..textDirection = Directionality.maybeOf(context);
  }
}

class _FlexGridParentData extends ContainerBoxParentData<RenderBox> {}

class RenderFlexGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FlexGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FlexGridParentData> {
  RenderFlexGrid({
    required int crossAxisCount,
    required double childAspectRatio,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
    required double mainAxisExtent,
    required Axis direction,
    required EdgeInsetsGeometry padding,
    TextDirection? textDirection,
  })  : _crossAxisCount = crossAxisCount,
        _childAspectRatio = childAspectRatio,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _mainAxisExtent = mainAxisExtent,
        _direction = direction,
        _padding = padding,
        _textDirection = textDirection;

  /// [crossAxisCount]
  int _crossAxisCount;

  int get crossAxisCount => _crossAxisCount;

  set crossAxisCount(int value) {
    if (_crossAxisCount == value) return;
    _crossAxisCount = value;
    markNeedsLayout();
  }

  /// [childAspectRatio]
  double _childAspectRatio;

  double get childAspectRatio => _childAspectRatio;

  set childAspectRatio(double value) {
    if (_childAspectRatio == value) return;
    _childAspectRatio = value;
    markNeedsLayout();
  }

  /// [mainAxisSpacing]
  double _mainAxisSpacing;

  double get mainAxisSpacing => _mainAxisSpacing;

  set mainAxisSpacing(double value) {
    if (_mainAxisSpacing == value) return;
    _mainAxisSpacing = value;
    markNeedsLayout();
  }

  /// [crossAxisSpacing]
  double _crossAxisSpacing;

  double get crossAxisSpacing => _crossAxisSpacing;

  set crossAxisSpacing(double value) {
    if (_crossAxisSpacing == value) return;
    _crossAxisSpacing = value;
    markNeedsLayout();
  }

  /// [mainAxisExtent]
  double _mainAxisExtent;

  double get mainAxisExtent => _mainAxisExtent;

  set mainAxisExtent(double value) {
    if (_mainAxisExtent == value) return;
    _mainAxisExtent = value;
    markNeedsLayout();
  }

  /// [direction]
  Axis _direction;

  Axis get direction => _direction;

  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  /// [padding]
  EdgeInsetsGeometry _padding;

  EdgeInsetsGeometry get padding => _padding;

  set padding(EdgeInsetsGeometry value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  /// [textDirection]
  TextDirection? _textDirection;

  TextDirection? get textDirection => _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  EdgeInsets get _resolvedPadding =>
      _padding.resolve(_textDirection ?? TextDirection.ltr);

  bool get _isVertical => _direction == Axis.vertical;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FlexGridParentData) {
      child.parentData = _FlexGridParentData();
    }
  }

  @override
  void performLayout() {
    final resolvedPadding = _resolvedPadding;
    final paddingHorizontal = resolvedPadding.left + resolvedPadding.right;
    final paddingVertical = resolvedPadding.top + resolvedPadding.bottom;

    final availableWidth = constraints.maxWidth - paddingHorizontal;
    final availableHeight = constraints.maxHeight - paddingVertical;

    final maxCrossAxisExtent = _isVertical ? availableWidth : availableHeight;
    final totalSpacing = (_crossAxisCount - 1) * _crossAxisSpacing;
    final childCrossAxisExtent =
        (maxCrossAxisExtent - totalSpacing) / _crossAxisCount;
    final childMainAxisExtent =
        childCrossAxisExtent / _childAspectRatio + _mainAxisExtent;

    final childConstraints = BoxConstraints.tight(
      _isVertical
          ? Size(childCrossAxisExtent, childMainAxisExtent)
          : Size(childMainAxisExtent, childCrossAxisExtent),
    );

    final paddingOffset = Offset(resolvedPadding.left, resolvedPadding.top);

    var index = 0;
    var child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);

      final row = index ~/ _crossAxisCount;
      final col = index % _crossAxisCount;

      final crossAxisOffset = col * (childCrossAxisExtent + _crossAxisSpacing);
      final mainAxisOffset = row * (childMainAxisExtent + _mainAxisSpacing);

      final parentData = child.parentData! as _FlexGridParentData
        ..offset = paddingOffset +
            (_isVertical
                ? Offset(crossAxisOffset, mainAxisOffset)
                : Offset(mainAxisOffset, crossAxisOffset));

      child = parentData.nextSibling;
      index++;
    }

    final rowCount = (index / _crossAxisCount).ceil();
    final totalMainAxisExtent = rowCount > 0
        ? rowCount * childMainAxisExtent + (rowCount - 1) * _mainAxisSpacing
        : 0.0;

    size = constraints.constrain(
      _isVertical
          ? Size(
              maxCrossAxisExtent + paddingHorizontal,
              totalMainAxisExtent + paddingVertical,
            )
          : Size(
              totalMainAxisExtent + paddingHorizontal,
              maxCrossAxisExtent + paddingVertical,
            ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
