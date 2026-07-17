part of '../../fluiver.dart';

/// Caret-preserving text replacement on [TextEditingController].
extension TextEditingControllerCaret on TextEditingController {
  /// Replaces the controller text and places the caret at [caret],
  /// or at the end of the new text when [caret] is `null`.
  ///
  /// Setting [TextEditingController.text] directly resets the caret to
  /// offset `0` — a well-known SDK papercut. This sets [value] in one
  /// shot so the caret lands where you asked. Out-of-range [caret] is
  /// clamped to `0..text.length`.
  ///
  /// ```dart
  /// controller.setTextAndCaret('hello');         // caret at 5 (end)
  /// controller.setTextAndCaret('hello', caret: 0); // caret at start
  /// ```
  void setTextAndCaret(String text, {int? caret}) {
    value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: (caret ?? text.length).clamp(0, text.length),
      ),
    );
  }
}
