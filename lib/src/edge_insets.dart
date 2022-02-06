part of dashx;

extension EdgeInsetsExtensions on EdgeInsets {
  ///
  /// Adders
  ///

  EdgeInsets addAll(double value) {
    return this + EdgeInsets.all(value);
  }

  EdgeInsets addLeft(double value) {
    return this + EdgeInsets.only(left: value);
  }

  EdgeInsets addTop(double value) {
    return this + EdgeInsets.only(top: value);
  }

  EdgeInsets addRight(double value) {
    return this + EdgeInsets.only(right: value);
  }

  EdgeInsets addBottom(double value) {
    return this + EdgeInsets.only(bottom: value);
  }

  EdgeInsets addVertical(double value) {
    return this + EdgeInsets.symmetric(vertical: value);
  }

  EdgeInsets addHorizontal(double value) {
    return this + EdgeInsets.symmetric(horizontal: value);
  }

  ///
  /// Setters
  ///

  EdgeInsets setLeft(double value) => copyWith(left: value);

  EdgeInsets setTop(double value) => copyWith(top: value);

  EdgeInsets setRight(double value) => copyWith(right: value);

  EdgeInsets setBottom(double value) => copyWith(bottom: value);

  EdgeInsets setVertical(double value) => copyWith(top: value, bottom: value);

  EdgeInsets setHorizontal(double value) => copyWith(left: value, right: value);

  ///
  /// Removers
  ///

  EdgeInsets get removeLeft => setLeft(0);

  EdgeInsets get removeTop => setTop(0);

  EdgeInsets get removeRight => setRight(0);

  EdgeInsets get removeBottom => setBottom(0);

  EdgeInsets get removeVertical => setVertical(0);

  EdgeInsets get removeHorizontal => setHorizontal(0);

  ///
  /// Eliminaters
  ///

  EdgeInsets get onlyLeft => copyWith(left: left);

  EdgeInsets get onlyTop => copyWith(top: top);

  EdgeInsets get onlyRight => copyWith(right: right);

  EdgeInsets get onlyBottom => copyWith(bottom: bottom);

  EdgeInsets get onlyVertical => copyWith(top: top, bottom: bottom);

  EdgeInsets get onlyHorizontal => copyWith(left: left, right: right);
}
