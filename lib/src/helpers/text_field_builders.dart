part of '../../fluiver.dart';

/// Reusable callbacks for [TextField]'s builder slots.
abstract final class TextFieldBuilders {
  /// Hides [TextField]'s built-in character counter.
  ///
  /// Pass to [TextField.buildCounter]:
  ///
  /// ```dart
  /// TextField(buildCounter: TextFieldBuilders.disabledCounter)
  /// ```
  static Widget? disabledCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) => null;
}
