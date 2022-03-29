part of fluiver;

// coverage:ignore-file

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get canRequestFocus => false;
}
