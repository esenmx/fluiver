part of fluiver;

class Def {
  const Def._();

  /// Reference: https://stackoverflow.com/a/49648870/10380182
  Future<bool> hasConnection() async {
    return InternetAddress.lookup('example.com')
        .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
        .catchError((error) => false);
  }

  /// Useful when you need to put a max len for input assertion and not for
  /// typical UX and you don't want to show [counterBuilder] just because of
  /// ```dart
  /// TextField(
  ///   maxLength: 100,
  ///   buildCounter: Typedefs.disabledInputCounterBuilder,
  /// );
  /// ```
  static InputCounterWidgetBuilder get disabledInputCounterBuilder {
    return (context, {int? currentLength, int? maxLength, bool? isFocused}) {
      return null;
    };
  }
}
