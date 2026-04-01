part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Kotlin-style `let` on any object.
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
