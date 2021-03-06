part of fluiver;

extension AddEdgeInsetsX on EdgeInsets {
  EdgeInsets addAll(double value) => this + EdgeInsets.all(value);

  EdgeInsets addLeft(double value) => this + EdgeInsets.only(left: value);

  EdgeInsets addTop(double value) => this + EdgeInsets.only(top: value);

  EdgeInsets addRight(double value) => this + EdgeInsets.only(right: value);

  EdgeInsets addBottom(double value) => this + EdgeInsets.only(bottom: value);
}

extension OnlyEdgeInsetsX on EdgeInsets {
  EdgeInsets get onlyLeft => EdgeInsets.only(left: left);

  EdgeInsets get onlyTop => EdgeInsets.only(top: top);

  EdgeInsets get onlyRight => EdgeInsets.only(right: right);

  EdgeInsets get onlyBottom => EdgeInsets.only(bottom: bottom);

  EdgeInsets get onlyVertical => EdgeInsets.only(top: top, bottom: bottom);

  EdgeInsets get onlyHorizontal => EdgeInsets.only(left: left, right: right);
}

extension SetEdgeInsetsX on EdgeInsets {
  EdgeInsets setLeft(double value) => copyWith(left: value);

  EdgeInsets setTop(double value) => copyWith(top: value);

  EdgeInsets setRight(double value) => copyWith(right: value);

  EdgeInsets setBottom(double value) => copyWith(bottom: value);
}

extension MediaQueryEdgeInsetsX on EdgeInsets {
  EdgeInsets withStatusBarMargin(BuildContext context) {
    return this + EdgeInsets.only(top: context.topPadding);
  }

  EdgeInsets withBottomBarMargin(BuildContext context) {
    return this + EdgeInsets.only(bottom: context.bottomPadding);
  }

  EdgeInsets withKeyboardInset(BuildContext context) {
    return this + EdgeInsets.only(bottom: context.bottomInset);
  }
}
