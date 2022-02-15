part of dashx;

extension AddEdgeInsetsExtensions on EdgeInsets {
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

extension RemoveEdgeInsetsExtensions on EdgeInsets {
  EdgeInsets get removeLeft => copyWith(left: 0);

  EdgeInsets get removeTop => copyWith(top: 0);

  EdgeInsets get removeRight => copyWith(right: 0);

  EdgeInsets get removeBottom => copyWith(bottom: 0);

  EdgeInsets get removeVertical => copyWith(top: 0, bottom: 0);

  EdgeInsets get removeHorizontal => copyWith(left: 0, right: 0);
}

extension OnlyEdgeInsetsExtensions on EdgeInsets {
  EdgeInsets get onlyLeft => EdgeInsets.only(left: left);

  EdgeInsets get onlyTop => EdgeInsets.only(top: top);

  EdgeInsets get onlyRight => EdgeInsets.only(right: right);

  EdgeInsets get onlyBottom => EdgeInsets.only(bottom: bottom);

  EdgeInsets get onlyVertical => EdgeInsets.only(top: top, bottom: bottom);

  EdgeInsets get onlyHorizontal => EdgeInsets.only(left: left, right: right);
}

extension MediaQueryEdgeInsetsExtensions on EdgeInsets {
  EdgeInsets withStatusBarMargin(BuildContext context) =>
      this + EdgeInsets.only(top: context.topPadding);

  EdgeInsets withBottomBarMargin(BuildContext context) =>
      this + EdgeInsets.only(bottom: context.bottomPadding);

  EdgeInsets withKeyboardInset(BuildContext context) =>
      this + EdgeInsets.only(bottom: context.bottomInset);
}
