part of fluiver;

// coverage:ignore-file

extension TextStyleX on TextStyle {
  /// [Roboto] is much more suitable for [Text] with special characters
  /// like currency symbols.
  /// Useful in case you want to override your default [TextStyle]
  TextStyle get familyRoboto => copyWith(fontFamily: 'Roboto');
}

extension TextStyleColorX on TextStyle {
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

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
  TextStyle primaryColor(BuildContext context) {
    return copyWith(color: context.primaryColor);
  }

  TextStyle secondaryColor(BuildContext context) {
    return copyWith(color: context.secondaryColor);
  }

  TextStyle surfaceColor(BuildContext context) {
    return copyWith(color: context.surfaceColor);
  }

  TextStyle backgroundColor(BuildContext context) {
    return copyWith(color: context.backgroundColor);
  }

  TextStyle errorColor(BuildContext context) {
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
  TextStyle get none => copyWith(decoration: TextDecoration.none);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}

/// Numbers have chosen from mostly:
/// https://material.io/design/typography/the-type-system.html#type-scale
extension TextStyleSizeX on TextStyle {
  TextStyle withSize(double size) => copyWith(fontSize: size);

  TextStyle get size10 => copyWith(fontSize: 10);

  TextStyle get size12 => copyWith(fontSize: 12);

  TextStyle get size14 => copyWith(fontSize: 14);

  TextStyle get size16 => copyWith(fontSize: 16);

  TextStyle get size18 => copyWith(fontSize: 18);

  TextStyle get size20 => copyWith(fontSize: 20);

  TextStyle get size24 => copyWith(fontSize: 24);

  TextStyle get size34 => copyWith(fontSize: 34);
}

/// Ignore [DefaultTextStyle] from [ThemeData] or [TextSpan]
/// Useful when you need to completely override inherited style
/// Defaults to [Colors.black87] instead of [Colors.white]
/// Defaults to [fontSize] to [14] instead of [10]
const kBlankTextStyle = TextStyle(
  inherit: false,
  color: Colors.black87,
  fontSize: 14,
);
