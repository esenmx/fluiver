part of fluiver;

/// Useful for simple use case with Material style [TextField/TextFormField].
/// Provides splash on top of the field with default respective size.
class FormSuffixButton extends RawMaterialButton {
  const FormSuffixButton.circle({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
    super.shape = const CircleBorder(),
  });

  FormSuffixButton.rectangle({
    super.key,
    required super.onPressed,
    required super.child,
    required BorderRadius borderRadius,
    super.padding,
  }) : super(shape: RoundedRectangleBorder(borderRadius: borderRadius));
}
