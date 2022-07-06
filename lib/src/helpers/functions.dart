part of fluiver;

abstract class Def {
  /// Useful when you need to put a max length for input consistency and do not
  /// want to show [counterBuilder] just because of it.
  /// ```dart
  /// TextField(
  ///   maxLength: 100,
  ///   buildCounter: Def.disabledInputCounterBuilder,
  /// );
  /// ```
  static InputCounterWidgetBuilder get disabledInputCounterBuilder {
    return (context, {int? currentLength, int? maxLength, bool? isFocused}) {
      return null;
    };
  }
}

abstract class NetDef {
  /// Checks whether device has connection to internet or not
  /// Reference: https://stackoverflow.com/a/49648870/10380182
  Future<bool> hasConnection() async {
    return InternetAddress.lookup('example.com')
        .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
        .catchError((error) => false);
  }
}
