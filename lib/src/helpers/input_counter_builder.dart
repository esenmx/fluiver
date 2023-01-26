part of fluiver;

class InputCounterBuilders {
  const InputCounterBuilders._();

  /// Useful when you need to put a max length for input consistency and do not
  /// want to show [counterBuilder] just because of it.
  /// ```dart
  /// TextField(
  ///   maxLength: 100,
  ///   buildCounter: Def.disabledInputCounterBuilder,
  /// );
  /// ```
  static InputCounterWidgetBuilder get disable {
    return (context, {required currentLength, required isFocused, maxLength}) {
      return null;
    };
  }

  static InputCounterWidgetBuilder minMax({
    required int minLength,
    TextStyle? style,
    Color? errorColor,
  }) {
    return (context, {required currentLength, required isFocused, maxLength}) {
      final effectiveErrorColor = errorColor ?? context.errorColor;
      var effectiveStyle = style ?? context.labelSmallTextStyle;
      void setErrorStyle() {
        effectiveStyle = effectiveStyle.copyWith(color: effectiveErrorColor);
      }

      final String? string;
      if (currentLength < minLength) {
        string = '$currentLength / $minLength';
        setErrorStyle();
      } else if (maxLength != null) {
        string = '$currentLength / $maxLength';
        if (currentLength > maxLength) {
          setErrorStyle();
        }
      } else {
        string = null;
      }
      if (string == null) {
        return null;
      }
      return Text(string, style: effectiveStyle);
    };
  }
}
