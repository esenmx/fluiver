part of fluiver;

class Def {
  const Def._();

  /// Useful when you need to put a max length for input consistency and do not
  /// want to show [counterBuilder] just because of it.
  /// ```dart
  /// TextField(
  ///   maxLength: 100,
  ///   buildCounter: Def.disabledInputCounterBuilder,
  /// );
  /// ```
  static InputCounterWidgetBuilder get disabledInputCounterBuilder {
    return (context, {required currentLength, required isFocused, maxLength}) {
      return null;
    };
  }

  static InputCounterWidgetBuilder inputCounterWithMinLength({
    required int minLength,
    TextStyle? style,
    Color? errorColor,
  }) {
    return (context, {required currentLength, required isFocused, maxLength}) {
      final effectiveErrorColor = errorColor ?? Theme.of(context).errorColor;
      var effectiveStyle = style ?? Theme.of(context).textTheme.caption;
      void setErrorStyle() {
        effectiveStyle = effectiveStyle?.copyWith(color: effectiveErrorColor);
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

class NetDef {
  const NetDef._();

  /// Checks whether device has connection to internet or not
  /// Reference: https://stackoverflow.com/a/49648870/10380182
  static Future<bool> hasConnection() async {
    return InternetAddress.lookup('example.com')
        .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
        .catchError((error) => false);
  }
}
