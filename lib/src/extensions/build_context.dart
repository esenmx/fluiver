part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Provides convenient access to [MediaQuery] properties.
extension BuildContextMediaQuery on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isPlatformDark => MediaQuery.platformBrightnessOf(this).isDark;
  bool get isPlatformLight => MediaQuery.platformBrightnessOf(this).isLight;

  bool get isOrientationPortrait => MediaQuery.orientationOf(this).isPortrait;
  bool get isOrientationLandscape => MediaQuery.orientationOf(this).isLandscape;

  double get topViewPadding => MediaQuery.viewPaddingOf(this).top;
  double get bottomViewPadding => MediaQuery.viewPaddingOf(this).bottom;
  double get bottomViewInset => MediaQuery.viewInsetsOf(this).bottom;
}

extension _BuildContext on BuildContext {
  ThemeData get _t => Theme.of(this);
}

/// {@macro extensionFor}
/// Checking theme brightness.
extension BuildContextThemeBrightness on BuildContext {
  bool get isThemeDark => _t.brightness.isDark;
  bool get isThemeLight => _t.brightness.isLight;
}

/// {@macro extensionFor}
/// Checking text direction.
extension BuildContextDirectionality on BuildContext {
  bool get isDirectionalityLtr => Directionality.of(this).isLtr;
  bool get isDirectionalityRtl => Directionality.of(this).isRtl;
}

/// {@macro extensionFor}
/// Provides convenient access to [TextTheme] styles.
extension BuildContextTextStyle on BuildContext {
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

/// {@macro extensionFor}
/// Provides convenient access to [ColorScheme] colors.
extension BuildContextsColorScheme on BuildContext {
  ColorScheme get _cs => _t.colorScheme;
  Color get primaryColor => _cs.primary;
  Color get onPrimaryColor => _cs.onPrimary;
  Color get primaryContainerColor => _cs.primaryContainer;
  Color get onPrimaryContainerColor => _cs.onPrimaryContainer;
  Color? get primaryFixedColor => _cs.primaryFixed;
  Color? get primaryFixedDimColor => _cs.primaryFixedDim;
  Color? get onPrimaryFixedColor => _cs.onPrimaryFixed;
  Color? get onPrimaryFixedVariantColor => _cs.onPrimaryFixedVariant;

  Color get secondaryColor => _cs.secondary;
  Color get onSecondaryColor => _cs.onSecondary;
  Color get secondaryContainerColor => _cs.secondaryContainer;
  Color get onSecondaryContainerColor => _cs.onSecondaryContainer;
  Color? get secondaryFixedColor => _cs.secondaryFixed;
  Color? get secondaryFixedDimColor => _cs.secondaryFixedDim;
  Color? get onSecondaryFixedColor => _cs.onSecondaryFixed;
  Color? get onSecondaryFixedVariantColor => _cs.onSecondaryFixedVariant;

  Color get tertiaryColor => _cs.tertiary;
  Color get onTertiaryColor => _cs.onTertiary;
  Color get tertiaryContainerColor => _cs.tertiaryContainer;
  Color get onTertiaryContainerColor => _cs.onTertiaryContainer;
  Color? get tertiaryFixedColor => _cs.tertiaryFixed;
  Color? get tertiaryFixedDimColor => _cs.tertiaryFixedDim;
  Color? get onTertiaryFixedColor => _cs.onTertiaryFixed;
  Color? get onTertiaryFixedVariantColor => _cs.onTertiaryFixedVariant;

  Color get errorColor => _cs.error;
  Color get onErrorColor => _cs.onError;
  Color get errorContainerColor => _cs.errorContainer;
  Color get onErrorContainerColor => _cs.onErrorContainer;

  Color get backgroundColor => _cs.surface;
  Color get onBackgroundColor => _cs.onSurface;

  Color get surfaceColor => _cs.surface;
  Color get onSurfaceColor => _cs.onSurface;
  Color get surfaceVariantColor => _cs.surfaceContainerHighest;
  Color get onSurfaceVariantColor => _cs.onSurfaceVariant;
  Color get inverseSurfaceColor => _cs.inverseSurface;
  Color get onInverseSurfaceColor => _cs.onInverseSurface;
  Color get inversePrimaryColor => _cs.inversePrimary;
  Color? get outlineColor => _cs.outline;
  Color? get outlineVariantColor => _cs.outlineVariant;
  Color? get shadowColor => _cs.shadow;
  Color? get scrimColor => _cs.scrim;
  Color? get surfaceTintColor => _cs.surfaceTint;

  Color? get surfaceBrightColor => _cs.surfaceBright;
  Color? get surfaceDimColor => _cs.surfaceDim;
  Color? get surfaceContainerLowestColor => _cs.surfaceContainerLowest;
  Color? get surfaceContainerLowColor => _cs.surfaceContainerLow;
  Color? get surfaceContainerColor => _cs.surfaceContainer;
  Color? get surfaceContainerHighColor => _cs.surfaceContainerHigh;
  Color? get surfaceContainerHighestColor => _cs.surfaceContainerHighest;

  Brightness get colorSchemeBrightness => _cs.brightness;
}
