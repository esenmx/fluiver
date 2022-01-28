part of dashx;

extension NavigatorExtensions on BuildContext {
  Future<T?> navigatorPush<T extends Object?>(Route<T> route) =>
      Navigator.of(this).push(route);

  Future<T?> navigatorPushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void navigatorPop<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(result);
}

extension MediaQueryExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isPlatformDark =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;

  bool get isPlatformLight =>
      MediaQuery.of(this).platformBrightness == Brightness.light;

  bool get isOrientationPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isOrientationLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  double get topPadding => MediaQuery.of(this).padding.top;

  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  double get topInset => MediaQuery.of(this).viewInsets.top;

  double get bottomInset => MediaQuery.of(this).viewInsets.bottom;
}

extension ThemeExtensions on BuildContext {
  BottomAppBarTheme get bottomAppBarTheme => Theme.of(this).bottomAppBarTheme;

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      Theme.of(this).bottomNavigationBarTheme;

  SwitchThemeData get switchTheme => Theme.of(this).switchTheme;
}

extension TextThemeExtensions on BuildContext {
  TextStyle get headline1TextStyle => Theme.of(this).textTheme.headline1!;

  TextStyle get headline2TextStyle => Theme.of(this).textTheme.headline2!;

  TextStyle get headline3TextStyle => Theme.of(this).textTheme.headline3!;

  TextStyle get headline4TextStyle => Theme.of(this).textTheme.headline4!;

  TextStyle get headline5TextStyle => Theme.of(this).textTheme.headline5!;

  TextStyle get headline6TextStyle => Theme.of(this).textTheme.headline6!;

  TextStyle get subtitle1TextStyle => Theme.of(this).textTheme.subtitle1!;

  TextStyle get subtitle2TextStyle => Theme.of(this).textTheme.subtitle2!;

  TextStyle get bodyText1TextStyle => Theme.of(this).textTheme.bodyText1!;

  TextStyle get bodyText2TextStyle => Theme.of(this).textTheme.bodyText2!;

  TextStyle get captionTextStyle => Theme.of(this).textTheme.caption!;

  TextStyle get buttonTextStyle => Theme.of(this).textTheme.button!;

  TextStyle get overlineTextStyle => Theme.of(this).textTheme.overline!;
}

extension BuildContextExtensions on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}
