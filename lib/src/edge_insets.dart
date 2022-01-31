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

  EdgeInsets setLeft(double value) => copyWith(left: value);

  EdgeInsets setTop(double value) => copyWith(top: value);

  EdgeInsets setRight(double value) => copyWith(right: value);

  EdgeInsets setBottom(double value) => copyWith(bottom: value);

  EdgeInsets setVertical(double value) => setTop(value).setBottom(value);

  EdgeInsets setHorizontal(double value) => setLeft(value).setRight(value);

  EdgeInsets get removeLeft => setLeft(0);

  EdgeInsets get removeTop => setTop(0);

  EdgeInsets get removeRight => setRight(0);

  EdgeInsets get removeBottom => setBottom(0);

  EdgeInsets get removeVertical => setVertical(0);

  EdgeInsets get removeHorizontal => setHorizontal(0);
}
