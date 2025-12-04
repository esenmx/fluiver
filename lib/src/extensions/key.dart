part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Validating and saving [FormFieldState] via [GlobalKey].
extension GlobalKeyFormFieldState on GlobalKey<FormFieldState<dynamic>> {
  bool validateAndSave() {
    final currentState = this.currentState;
    assert(currentState != null, 'FormField is not attached to this key');
    if (currentState == null) {
      return false;
    }
    final isValid = currentState.validate();
    if (isValid) {
      currentState.save();
    }
    return isValid;
  }
}
