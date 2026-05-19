part of '../../fluiver.dart';

/// `Padding` + `Flex` composition. Two render objects, not one — but the
/// alternative (a custom `MultiChildRenderObjectWidget` re-implementing all
/// of `Flex`'s main/cross/baseline logic) costs hundreds of lines and a
/// real bug surface for negligible perf gain. Composition is the right
/// tool for glue widgets.
///
/// For raw-RenderObject grid layout, see [FlexGrid].
class PaddedFlex extends StatelessWidget {
  /// Creates a padded flex layout.
  const PaddedFlex({
    required this.direction,
    required this.padding,
    required this.children,
    this.mainAxisAlignment = .start,
    this.crossAxisAlignment = .center,
    this.spacing = 0.0,
    this.mainAxisSize = .max,
    this.verticalDirection = .down,
    this.textBaseline,
    this.textDirection,
    this.clipBehavior = .none,
    super.key,
  });

  /// Forwarded to [Flex.direction].
  final Axis direction;

  /// Forwarded to [Padding.padding].
  final EdgeInsetsGeometry padding;

  /// Forwarded to [Flex.children].
  final List<Widget> children;

  /// Forwarded to [Flex.spacing].
  final double spacing;

  /// Forwarded to [Flex.mainAxisAlignment].
  final MainAxisAlignment mainAxisAlignment;

  /// Forwarded to [Flex.crossAxisAlignment].
  final CrossAxisAlignment crossAxisAlignment;

  /// Forwarded to [Flex.mainAxisSize].
  final MainAxisSize mainAxisSize;

  /// Forwarded to [Flex.textBaseline]; `null` falls back to default.
  final TextBaseline? textBaseline;

  /// Forwarded to [Flex.textDirection]; `null` resolves from ambient
  /// [Directionality].
  final TextDirection? textDirection;

  /// Forwarded to [Flex.verticalDirection].
  final VerticalDirection verticalDirection;

  /// Forwarded to [Flex.clipBehavior].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Flex(
        direction: direction,
        spacing: spacing,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        textBaseline: textBaseline,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        children: children,
      ),
    );
  }
}

/// [PaddedFlex] with [Axis.horizontal].
class PaddedRow extends PaddedFlex {
  /// Creates a padded row.
  const PaddedRow({
    required super.padding,
    required super.children,
    super.spacing,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.key,
  }) : super(direction: .horizontal);
}

/// [PaddedFlex] with [Axis.vertical].
class PaddedColumn extends PaddedFlex {
  /// Creates a padded column.
  const PaddedColumn({
    required super.padding,
    required super.children,
    super.spacing,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.key,
  }) : super(direction: .vertical);
}
