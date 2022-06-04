part of fluiver;

abstract class Typedefs {
  /// Useful when you need to put a max len for data consistency and not for UX
  /// and you don't want to show [counterBuilder] just because of that
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
