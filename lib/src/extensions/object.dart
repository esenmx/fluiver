part of '../../fluiver.dart';

extension Let<T> on T {
  /// Returns `this` after applying `fn` to it.
  ///
  /// ```dart
  /// int? function(String? param) {
  ///   return param?.let(int.tryParse);
  /// }
  /// ```
  R let<R>(R Function(T it) fn) => fn(this);
}
