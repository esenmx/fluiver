part of '../../fluiver.dart';

/// Null-on-timeout variant of [Future.timeout].
extension FutureTimeout<T> on Future<T> {
  /// Returns `null` instead of throwing on [TimeoutException].
  ///
  /// Errors from the underlying future still propagate — only the
  /// timeout itself is converted to `null`.
  ///
  /// ```dart
  /// final user = await fetchUser().timeoutOrNull(const Duration(seconds: 2));
  /// if (user == null) {
  ///   showRetry();
  /// }
  /// ```
  Future<T?> timeoutOrNull(Duration timeout) {
    return then<T?>((v) => v).timeout(timeout, onTimeout: () => null);
  }
}
