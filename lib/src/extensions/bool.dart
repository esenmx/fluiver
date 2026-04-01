part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Converting [bool] to [int].
extension BoolInt on bool {
  /// Returns `1` for `true`, `0` for `false`.
  int toInt() => this ? 1 : 0;
}
