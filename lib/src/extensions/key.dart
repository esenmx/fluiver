part of '../../fluiver.dart';

extension GlobalKeyFormFieldState on GlobalKey<FormFieldState> {
  bool validateAndSave() {
    final isValid = currentState?.validate() == true;
    if (isValid) {
      currentState?.save();
    }
    return isValid;
  }
}
