part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Validating and saving [FormFieldState] via [GlobalKey].
extension GlobalKeyFormFieldState<T> on GlobalKey<FormFieldState<T>> {
  bool validateAndSave() {
    final currentState = this.currentState;
    assert(currentState != null, 'FormField<$T> is not attached to this key');
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
