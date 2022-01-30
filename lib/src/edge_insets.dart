part of dashx;

extension EdgeInsetsExtensions on EdgeInsets {
  EdgeInsets addAll(double value) => this + EdgeInsets.all(value);

  EdgeInsets addLeft(double value) => this + EdgeInsets.only(left: value);

  EdgeInsets addTop(double value) => this + EdgeInsets.only(top: value);

  EdgeInsets addRight(double value) => this + EdgeInsets.only(right: value);

  EdgeInsets addBottom(double value) => this + EdgeInsets.only(bottom: value);

  EdgeInsets addVertical(double value) =>
      this + EdgeInsets.symmetric(vertical: value);

  EdgeInsets addHorizontal(double value) =>
      this + EdgeInsets.symmetric(horizontal: value);
}
