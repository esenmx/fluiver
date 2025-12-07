part of '../../fluiver.dart';

class PaddedFlex extends StatelessWidget {
  const PaddedFlex({
    required this.direction,
    required this.padding,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDirection = TextDirection.ltr,
    this.clipBehavior = Clip.none,
    super.key,
  });

  final Axis direction;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline textBaseline;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
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

class PaddedRow extends PaddedFlex {
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
  }) : super(direction: Axis.horizontal);
}

class PaddedColumn extends PaddedFlex {
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
  }) : super(direction: Axis.vertical);
}
