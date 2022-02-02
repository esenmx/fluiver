part of dashx;

extension BuildContextShortCutExtensions on BuildContext {
  ThemeData get _t => Theme.of(this);

  MediaQueryData get _m => MediaQuery.of(this);

  NavigatorState get _n => Navigator.of(this);
}

extension NavigatorExtensions on BuildContext {
  Future<T?> navigatorPush<T extends Object?>(Route<T> route) => _n.push(route);

  Future<T?> navigatorPushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _n.pushNamed(routeName, arguments: arguments);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    return _n.pushAndRemoveUntil(newRoute, predicate);
  }

  void navigatorPop<T extends Object?>([T? result]) => _n.pop(result);

  void navigatorPopUntil(RoutePredicate predicate) => _n.popUntil(predicate);
}

extension MediaQueryExtensions on BuildContext {
  double get screenWidth => _m.size.width;

  double get screenHeight => _m.size.height;

  bool get isPlatformDark => _m.platformBrightness == Brightness.dark;

  bool get isPlatformLight => _m.platformBrightness == Brightness.light;

  bool get isOrientationPortrait => _m.orientation == Orientation.portrait;

  bool get isOrientationLandscape => _m.orientation == Orientation.landscape;

  double get topPadding => _m.padding.top;

  double get bottomPadding => _m.padding.bottom;

  double get topInset => _m.viewInsets.top;

  double get bottomInset => _m.viewInsets.bottom;
}

extension TextThemeExtensions on BuildContext {
  TextStyle get headline1TextStyle => _t.textTheme.headline1!;

  TextStyle get headline2TextStyle => _t.textTheme.headline2!;

  TextStyle get headline3TextStyle => _t.textTheme.headline3!;

  TextStyle get headline4TextStyle => _t.textTheme.headline4!;

  TextStyle get headline5TextStyle => _t.textTheme.headline5!;

  TextStyle get headline6TextStyle => _t.textTheme.headline6!;

  TextStyle get subtitle1TextStyle => _t.textTheme.subtitle1!;

  TextStyle get subtitle2TextStyle => _t.textTheme.subtitle2!;

  TextStyle get bodyText1TextStyle => _t.textTheme.bodyText1!;

  TextStyle get bodyText2TextStyle => _t.textTheme.bodyText2!;

  TextStyle get captionTextStyle => _t.textTheme.caption!;

  TextStyle get buttonTextStyle => _t.textTheme.button!;

  TextStyle get overlineTextStyle => _t.textTheme.overline!;
}

extension BuildContextDirectionalityExtensions on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}

extension BuildContextColorExtensions on BuildContext {
  Color get primaryColor => _t.primaryColor;

  Color get primaryColorDark => _t.primaryColorDark;

  Color get primaryColorLight => _t.primaryColorLight;

  Color get secondaryColor => _t.colorScheme.secondary;

  Color get surfaceColor => _t.colorScheme.surface;

  Color get backgroundColor => _t.colorScheme.background;

  Color get errorColor => _t.colorScheme.error;
}

extension BuildContextLocaleExtensions on BuildContext {
  Locale get localeOf => Localizations.localeOf(this);

  String get languageCode => Localizations.localeOf(this).languageCode;

  String? get countryCode => Localizations.localeOf(this).countryCode;
}
