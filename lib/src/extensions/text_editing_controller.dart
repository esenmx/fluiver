import 'package:flutter/widgets.dart';

/// Text replacement with an explicit caret on [TextEditingController].
extension TextEditingControllerCaret on TextEditingController {
  /// Replaces the controller text and places the caret at [caret],
  /// or at the end of the new text when [caret] is `null`.
  ///
  /// Setting [TextEditingController.text] directly drops the selection to
  /// `TextSelection.invalid` (offset `-1`), and a focused field then repairs it
  /// its own way: the caret at the end on mobile and in multiline fields, the
  /// whole text selected in a single-line desktop field. This sets [value] in
  /// one shot, so the caret is valid and where you asked, focused or not.
  /// Throws [RangeError] if [caret] is outside `0..text.length`.
  ///
  /// ```dart
  /// controller.setTextAndCaret('hello');         // caret at 5 (end)
  /// controller.setTextAndCaret('hello', caret: 0); // caret at start
  /// ```
  void setTextAndCaret(String text, {int? caret}) {
    if (caret != null) {
      RangeError.checkValueInInterval(caret, 0, text.length, 'caret');
    }
    value = TextEditingValue(
      text: text,
      selection: .collapsed(offset: caret ?? text.length),
    );
  }
}
