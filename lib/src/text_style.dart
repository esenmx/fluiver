part of dashx;

extension TextStyleExtensions on TextStyle {
  /// [Roboto] is much more suitable for [Text] with special characters
  /// like currency symbols.
  /// Useful in case you want to override your default [TextStyle]
  TextStyle get familyRoboto => copyWith(fontFamily: 'Roboto');
}

extension TextStyleColorExtensions on TextStyle {
  /// x * .2
  TextStyle get opacity20 => copyWith(color: color?.withOpacity(.2));

  TextStyle get opacity40 => copyWith(color: color?.withOpacity(.4));

  TextStyle get opacity60 => copyWith(color: color?.withOpacity(.6));

  TextStyle get opacity80 => copyWith(color: color?.withOpacity(.8));

  /// x * .25
  TextStyle get opacity25 => copyWith(color: color?.withOpacity(.25));

  TextStyle get opacity50 => copyWith(color: color?.withOpacity(.5));

  TextStyle get opacity75 => copyWith(color: color?.withOpacity(.75));

  /// [Colors.white]
  TextStyle get white38 => copyWith(color: Colors.white38);

  TextStyle get white54 => copyWith(color: Colors.white54);

  TextStyle get white70 => copyWith(color: Colors.white70);

  TextStyle get white => copyWith(color: Colors.white);

  /// [Colors.black]
  TextStyle get black38 => copyWith(color: Colors.black38);

  TextStyle get black54 => copyWith(color: Colors.black54);

  TextStyle get black70 => copyWith(color: const Color(0xB3000000));

  TextStyle get black87 => copyWith(color: Colors.black87);

  TextStyle get black => copyWith(color: Colors.black);

  /// [ColorScheme]
  TextStyle primary(BuildContext context) {
    return copyWith(color: context.primaryColor);
  }

  TextStyle primaryDark(BuildContext context) {
    return copyWith(color: context.primaryColorDark);
  }

  TextStyle primaryLight(BuildContext context) {
    return copyWith(color: context.primaryColorLight);
  }

  TextStyle secondary(BuildContext context) {
    return copyWith(color: context.secondaryColor);
  }

  TextStyle surface(BuildContext context) {
    return copyWith(color: context.surfaceColor);
  }

  TextStyle background(BuildContext context) {
    return copyWith(color: context.backgroundColor);
  }

  TextStyle error(BuildContext context) {
    return copyWith(color: context.errorColor);
  }
}

extension TextStyleFontWeightExtensions on TextStyle {
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

extension TextStyleDecorationExtensions on TextStyle {
  TextStyle get none => copyWith(decoration: TextDecoration.none);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}

/// Numbers have chosen from mostly:
/// https://material.io/design/typography/the-type-system.html#type-scale
extension TextStyleSizeExtensions on TextStyle {
  TextStyle get size10 => copyWith(fontSize: 10);

  TextStyle get size12 => copyWith(fontSize: 12);

  TextStyle get size14 => copyWith(fontSize: 14);

  TextStyle get size16 => copyWith(fontSize: 16);

  TextStyle get size18 => copyWith(fontSize: 18);

  TextStyle get size20 => copyWith(fontSize: 20);

  TextStyle get size24 => copyWith(fontSize: 24);

  TextStyle get size34 => copyWith(fontSize: 34);
}

extension TextStyleUtilityExtensions on TextStyle {
  /// For blanking [DefaultTextStyle] from [ThemeData]
  /// Useful when you need to completely override default style
  /// Defaults to [Colors.black87] and [fontSize] to [14]
  TextStyle get clear => const TextStyle(
        inherit: false,
        color: Colors.black87,
        fontSize: 14,
      );
}
