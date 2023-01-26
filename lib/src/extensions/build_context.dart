part of fluiver;

extension _BuildContextX on BuildContext {
  MediaQueryData get _m => MediaQuery.of(this);

  ThemeData get _t => Theme.of(this);
}

extension BuildContextMediaQueryX on BuildContext {
  double get screenWidth => _m.size.width;
  double get screenHeight => _m.size.height;

  bool get isPlatformDark => _m.platformBrightness.isDark;
  bool get isPlatformLight => _m.platformBrightness.isLight;

  bool get isOrientationPortrait => _m.orientation.isPortrait;
  bool get isOrientationLandscape => _m.orientation.isLandscape;

  double get topViewPadding => _m.viewPadding.top;
  double get bottomViewPadding => _m.viewPadding.bottom;
  double get bottomViewInset => _m.viewInsets.bottom;
}

extension BuildContextThemeDataX on BuildContext {
  bool get isThemeDark => _t.brightness.isDark;
  bool get isThemeLight => _t.brightness.isLight;
}

extension TextThemeX on BuildContext {
  TextStyle get displayLargeTextStyle => _t.textTheme.displayLarge!;
  TextStyle get displayMediumTextStyle => _t.textTheme.displayMedium!;
  TextStyle get displaySmallTextStyle => _t.textTheme.displaySmall!;

  TextStyle get headlineLargeTextStyle => _t.textTheme.headlineLarge!;
  TextStyle get headlineMediumTextStyle => _t.textTheme.headlineMedium!;
  TextStyle get headlineSmallTextStyle => _t.textTheme.headlineSmall!;

  TextStyle get titleLargeTextStyle => _t.textTheme.titleLarge!;
  TextStyle get titleMediumTextStyle => _t.textTheme.titleMedium!;
  TextStyle get titleSmallTextStyle => _t.textTheme.titleSmall!;

  TextStyle get bodyLargeTextStyle => _t.textTheme.bodyLarge!;
  TextStyle get bodyMediumTextStyle => _t.textTheme.bodyMedium!;
  TextStyle get bodySmallTextStyle => _t.textTheme.bodySmall!;

  TextStyle get labelLargeTextStyle => _t.textTheme.labelLarge!;
  TextStyle get labelMediumTextStyle => _t.textTheme.labelMedium!;
  TextStyle get labelSmallTextStyle => _t.textTheme.labelSmall!;
}

extension BuildContextDirectionalityX on BuildContext {
  bool get isDirectionalityLtr => Directionality.of(this).isLtr;
  bool get isDirectionalityRtl => Directionality.of(this).isRtl;
}

extension BuildContextsColorSchemeX on BuildContext {
  Color get primaryColor => _t.colorScheme.primary;
  Color get onPrimaryColor => _t.colorScheme.onPrimary;
  Color get primaryContainerColor => _t.colorScheme.primaryContainer;
  Color get onPrimaryContainerColor => _t.colorScheme.onPrimaryContainer;
  Color get secondaryColor => _t.colorScheme.secondary;
  Color get onSecondaryColor => _t.colorScheme.onSecondary;
  Color get secondaryContainerColor => _t.colorScheme.secondaryContainer;
  Color get onSecondaryContainerColor => _t.colorScheme.onSecondaryContainer;
  Color get tertiaryColor => _t.colorScheme.tertiary;
  Color get onTertiaryColor => _t.colorScheme.onTertiary;
  Color get tertiaryContainerColor => _t.colorScheme.tertiaryContainer;
  Color get onTertiaryContainerColor => _t.colorScheme.onTertiaryContainer;
  Color get errorColor => _t.colorScheme.error;
  Color get onErrorColor => _t.colorScheme.onError;
  Color get errorContainerColor => _t.colorScheme.errorContainer;
  Color get onErrorContainerColor => _t.colorScheme.onErrorContainer;
  Color get outlineColor => _t.colorScheme.outline;
  Color get outlineVariantColor => _t.colorScheme.outlineVariant;
  Color get backgroundColor => _t.colorScheme.background;
  Color get onBackgroundColor => _t.colorScheme.onBackground;
  Color get surfaceColor => _t.colorScheme.surface;
  Color get onSurfaceColor => _t.colorScheme.onSurface;
  Color get surfaceVariantColor => _t.colorScheme.surfaceVariant;
  Color get onSurfaceVariantColor => _t.colorScheme.onSurfaceVariant;
  Color get inverseSurfaceColor => _t.colorScheme.inverseSurface;
  Color get onInverseSurfaceColor => _t.colorScheme.onInverseSurface;
  Color get inversePrimaryColor => _t.colorScheme.inversePrimary;
  Color get shadowColor => _t.colorScheme.shadow;
  Color get scrimColor => _t.colorScheme.scrim;
  Color get surfaceTintColor => _t.colorScheme.surfaceTint;
}
