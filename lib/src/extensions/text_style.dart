part of fluiver;

extension TextStyleFamily on TextStyle {
  /// [Roboto] is much more suitable for [Text] with special characters
  /// like `currency symbols`.
  ///
  /// Useful in case you want to override your default [TextStyle]
  TextStyle get withRobotoFamily => copyWith(fontFamily: 'Roboto');
}

extension TextStyleColor on TextStyle {
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  /// [Colors.white]
  TextStyle get withColorWhite38 => copyWith(color: Colors.white38);

  TextStyle get withColorWhite54 => copyWith(color: Colors.white54);

  TextStyle get withColorWhite70 => copyWith(color: Colors.white70);

  TextStyle get withColorWhite => copyWith(color: Colors.white);

  /// [Colors.black]
  TextStyle get withColorBlack38 => copyWith(color: Colors.black38);

  TextStyle get withColorBlack54 => copyWith(color: Colors.black54);

  TextStyle get withColorBlack70 => copyWith(color: const Color(0xB3000000));

  TextStyle get withColorBlack87 => copyWith(color: Colors.black87);

  TextStyle get withColorBlack => copyWith(color: Colors.black);

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

extension TextStyleFontWeight on TextStyle {
  /// [Thin]
  TextStyle get withWeight100 => copyWith(fontWeight: FontWeight.w100);

  /// [ExtraLight]
  TextStyle get withWeight200 => copyWith(fontWeight: FontWeight.w200);

  /// [Light]
  TextStyle get withWeight300 => copyWith(fontWeight: FontWeight.w300);

  /// [Regular]
  TextStyle get withWeight400 => copyWith(fontWeight: FontWeight.w400);

  /// [Medium]
  TextStyle get withWeight500 => copyWith(fontWeight: FontWeight.w500);

  /// [SemiBold]
  TextStyle get withWeight600 => copyWith(fontWeight: FontWeight.w600);

  /// [Bold]
  TextStyle get withWeight700 => copyWith(fontWeight: FontWeight.w700);

  /// [ExtraBold]
  TextStyle get withWeight800 => copyWith(fontWeight: FontWeight.w800);

  /// [Thick]
  TextStyle get withWeight900 => copyWith(fontWeight: FontWeight.w900);
}

extension TextStyleDecoration on TextStyle {
  TextStyle get withUnderline => copyWith(decoration: TextDecoration.underline);

  TextStyle get withOverline => copyWith(decoration: TextDecoration.overline);

  TextStyle get withLineThrough =>
      copyWith(decoration: TextDecoration.lineThrough);
}

extension TextStyleSize on TextStyle {
  TextStyle withSize(double size) => copyWith(fontSize: size);
}
