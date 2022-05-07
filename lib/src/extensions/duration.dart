part of fluiver;

extension DurationX on Duration {
  ///
  /// ```dart
  /// print(DurationX.weeks(4).inDays); // prints 28
  /// ```
  ///
  static Duration weeks(int w) => Duration(days: w * 7);
}
