part of fluiver;

extension TextStyleX on TextStyle {
  /// [Roboto] is much more suitable for [Text] with special characters
  /// like `currency symbols`.
  ///
  /// Useful in case you want to override your default [TextStyle]
  TextStyle get withRobotoFamily => copyWith(fontFamily: 'Roboto');
}

extension TextStyleColorX on TextStyle {
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  /// [Colors.white]
  TextStyle get colorWhite38 => copyWith(color: Colors.white38);

  TextStyle get colorWhite54 => copyWith(color: Colors.white54);

  TextStyle get colorWhite70 => copyWith(color: Colors.white70);

  TextStyle get colorWhite => copyWith(color: Colors.white);

  /// [Colors.black]
  TextStyle get colorBlack38 => copyWith(color: Colors.black38);

  TextStyle get colorBlack54 => copyWith(color: Colors.black54);

  TextStyle get colorBlack70 => copyWith(color: const Color(0xB3000000));

  TextStyle get colorBlack87 => copyWith(color: Colors.black87);

  TextStyle get colorBlack => copyWith(color: Colors.black);

  /// [ColorScheme]
  TextStyle withPrimaryColor(BuildContext context) {
    return copyWith(color: context.primaryColor);
  }

  TextStyle withSecondaryColor(BuildContext context) {
    return copyWith(color: context.secondaryColor);
  }

  TextStyle withErrorColor(BuildContext context) {
    return copyWith(color: context.errorColor);
  }
}

extension TextStyleFontWeightX on TextStyle {
  /// [Thin]
  TextStyle get weight100 => copyWith(fontWeight: FontWeight.w100);

  /// [ExtraLight]
  TextStyle get weight200 => copyWith(fontWeight: FontWeight.w200);

  /// [Light]
  TextStyle get weight300 => copyWith(fontWeight: FontWeight.w300);

  /// [Regular]
  TextStyle get weight400 => copyWith(fontWeight: FontWeight.w400);

  /// [Medium]
  TextStyle get weight500 => copyWith(fontWeight: FontWeight.w500);

  /// [SemiBold]
  TextStyle get weight600 => copyWith(fontWeight: FontWeight.w600);

  /// [Bold]
  TextStyle get weight700 => copyWith(fontWeight: FontWeight.w700);

  /// [ExtraBold]
  TextStyle get weight800 => copyWith(fontWeight: FontWeight.w800);

  /// [Thick]
  TextStyle get weight900 => copyWith(fontWeight: FontWeight.w900);
}

extension TextStyleDecorationX on TextStyle {
  TextStyle get withUnderline => copyWith(decoration: TextDecoration.underline);

  TextStyle get withOverline => copyWith(decoration: TextDecoration.overline);

  TextStyle get withLineThrough =>
      copyWith(decoration: TextDecoration.lineThrough);
}

/// Numbers have chosen from mostly:
/// https://m3.material.io/styles/typography/type-scale-tokens
extension TextStyleSizeX on TextStyle {
  TextStyle withSize(double size) => copyWith(fontSize: size);

  TextStyle get withSize10 => copyWith(fontSize: 10);

  TextStyle get withSize11 => copyWith(fontSize: 11);

  TextStyle get withSize12 => copyWith(fontSize: 12);

  TextStyle get withSize14 => copyWith(fontSize: 14);

  TextStyle get withSize16 => copyWith(fontSize: 16);

  TextStyle get withSize22 => copyWith(fontSize: 22);

  TextStyle get withSize24 => copyWith(fontSize: 24);
}
