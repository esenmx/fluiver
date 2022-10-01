part of fluiver;

/// Useful for simple use case with Material style [TextField/TextFormField].
/// Provides splash on top of the field with default respective size.
///
/// ```dart
/// TextField(
///   decoration: InputDecoration(
///     suffixIcon: FormSuffixButton.circle(
///       child: const Icon(Icons.backspace),
///       onPressed: () {},
///     ),
///   ),
/// )
/// ```
class FormSuffixButton extends _FormSuffixButton {
  /// [CircleBorder] splash
  const FormSuffixButton.circle({
    super.key,
    required super.onPressed,
    required Widget icon,
    super.padding,
    super.constraints = const BoxConstraints(minWidth: 24, minHeight: 24),
    super.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(child: icon, shape: const CircleBorder());

  /// [RoundedRectangleBorder] splash
  FormSuffixButton.rectangle({
    super.key,
    required super.onPressed,
    required Widget icon,
    required BorderRadius borderRadius,
    super.padding,
    super.constraints = const BoxConstraints(minWidth: 24, minHeight: 24),
    super.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(
          child: icon,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );
}

class _FormSuffixButton extends RawMaterialButton {
  const _FormSuffixButton({
    super.key,
    required super.onPressed,
    super.child,
    super.shape,
    super.padding,
    super.constraints,
    super.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
        );
}
