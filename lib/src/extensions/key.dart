part of fluiver;

extension FormFieldStateX on GlobalKey<FormFieldState> {
  bool validateAndSave() {
    final isValid = currentState?.validate() == true;
    if (isValid) {
      currentState?.save();
    }
    return isValid;
  }
}
