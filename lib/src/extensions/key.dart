part of fluiver;

extension GlobalKeyFormFieldStateX on GlobalKey<FormFieldState> {
  bool validateAndSave() {
    final isValid = currentState?.validate() == true;
    if (isValid) {
      currentState?.save();
    }
    return isValid;
  }
}
