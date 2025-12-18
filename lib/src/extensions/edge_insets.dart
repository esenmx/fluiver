part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Adding padding values to [EdgeInsets].
extension EdgeInsetsAdd on EdgeInsets {
  EdgeInsets addAll(double value) => this + .all(value);

  EdgeInsets addLeft(double value) => this + .only(left: value);
  EdgeInsets addTop(double value) => this + .only(top: value);
  EdgeInsets addRight(double value) => this + .only(right: value);
  EdgeInsets addBottom(double value) => this + .only(bottom: value);
}

/// {@macro extensionFor}
/// Extracting specific sides from [EdgeInsets].
extension EdgeInsetsOnly on EdgeInsets {
  EdgeInsets get onlyLeft => .only(left: left);
  EdgeInsets get onlyTop => .only(top: top);
  EdgeInsets get onlyRight => .only(right: right);
  EdgeInsets get onlyBottom => .only(bottom: bottom);

  EdgeInsets get onlyVertical => .only(top: top, bottom: bottom);
  EdgeInsets get onlyHorizontal => .only(left: left, right: right);
}

/// {@macro extensionFor}
/// Setting padding values on [EdgeInsets].
extension EdgeInsetsSet on EdgeInsets {
  EdgeInsets setLeft(double value) => copyWith(left: value);
  EdgeInsets setTop(double value) => copyWith(top: value);
  EdgeInsets setRight(double value) => copyWith(right: value);
  EdgeInsets setBottom(double value) => copyWith(bottom: value);

  EdgeInsets setHorizontal(double value) => copyWith(left: value, right: value);
  EdgeInsets setVertical(double value) => copyWith(bottom: value, top: value);
}

/// {@macro extensionFor}
/// Applying [MediaQuery] insets to [EdgeInsets].
extension EdgeInsetsMediaQuery on EdgeInsets {
  EdgeInsets withStatusBarMargin(BuildContext context) {
    return this + .only(top: context.topViewPadding);
  }

  EdgeInsets withBottomBarMargin(BuildContext context) {
    return this + .only(bottom: context.bottomViewPadding);
  }

  EdgeInsets withKeyboardInset(BuildContext context) {
    return this + .only(bottom: context.bottomViewInset);
  }
}
