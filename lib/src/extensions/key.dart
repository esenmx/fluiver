part of fluiver;

extension FormFieldStateX on GlobalKey<FormFieldState> {
  bool validateSave() {
    final isValid = currentState?.validate() == true;
    currentState?.save();
    return isValid;
  }
}
