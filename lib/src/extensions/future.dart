import 'dart:async';

/// Null-on-timeout variant of [Future.timeout].
///
/// Only for futures of non-nullable values, so `null` always means the
/// timeout elapsed; use [Future.timeout] for a `Future<T?>`.
extension FutureTimeout<T extends Object> on Future<T> {
  /// Returns `null` instead of throwing on [TimeoutException].
  ///
  /// Errors from the underlying future still propagate — only the
  /// timeout itself is converted to `null`. Throws [ArgumentError] if
  /// [timeout] is negative.
  ///
  /// ```dart
  /// final user = await fetchUser().timeoutOrNull(const Duration(seconds: 2));
  /// if (user == null) {
  ///   showRetry();
  /// }
  /// ```
  Future<T?> timeoutOrNull(Duration timeout) {
    if (timeout.isNegative) {
      throw ArgumentError.value(timeout, 'timeout', 'must not be negative');
    }
    return then<T?>((v) => v).timeout(timeout, onTimeout: () => null);
  }
}
