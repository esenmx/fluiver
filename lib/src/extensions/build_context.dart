part of fluiver;

// coverage:ignore-file

extension _BuildContextInternal on BuildContext {
  MediaQueryData get _m => MediaQuery.of(this);

  ThemeData get _t => Theme.of(this);
}

extension BuildContextMediaQuery on BuildContext {
  double get screenWidth => _m.size.width;

  double get screenHeight => _m.size.height;

  bool get isPlatformDark => _m.platformBrightness == Brightness.dark;

  bool get isPlatformLight => _m.platformBrightness == Brightness.light;

  bool get isOrientationPortrait => _m.orientation == Orientation.portrait;

  bool get isOrientationLandscape => _m.orientation == Orientation.landscape;

  double get topPadding => _m.padding.top;

  double get bottomPadding => _m.padding.bottom;

  double get bottomInset => _m.viewInsets.bottom;
}

extension BuildContextTheme on BuildContext {
  bool get isThemeDark => _t.brightness == Brightness.dark;

  bool get isThemeLight => _t.brightness == Brightness.light;
}

extension BuildContextTextTheme on BuildContext {
  TextStyle get headline1TextStyle => _t.textTheme.headline1!;

  TextStyle get headline2TextStyle => _t.textTheme.headline2!;

  TextStyle get headline3TextStyle => _t.textTheme.headline3!;

  TextStyle get headline4TextStyle => _t.textTheme.headline4!;

  TextStyle get headline5TextStyle => _t.textTheme.headline5!;

  TextStyle get headline6TextStyle => _t.textTheme.headline6!;

  TextStyle get subtitle1TextStyle => _t.textTheme.subtitle1!;

  TextStyle get subtitle2TextStyle => _t.textTheme.subtitle2!;

  TextStyle get body1TextStyle => _t.textTheme.bodyText1!;

  TextStyle get body2TextStyle => _t.textTheme.bodyText2!;

  TextStyle get captionTextStyle => _t.textTheme.caption!;

  TextStyle get buttonTextStyle => _t.textTheme.button!;

  TextStyle get overlineTextStyle => _t.textTheme.overline!;
}

extension BuildContextDirectionality on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}

extension BuildContextColorScheme on BuildContext {
  Color get primaryColor => _t.colorScheme.primary;

  Color get primaryContainerColor => _t.colorScheme.primaryContainer;

  Color get secondaryColor => _t.colorScheme.secondary;

  Color get surfaceColor => _t.colorScheme.surface;

  Color get backgroundColor => _t.colorScheme.background;

  Color get errorColor => _t.colorScheme.error;
}
