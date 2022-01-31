part of dashx;

extension TextStyleExtensions on TextStyle {
  /// [Roboto] is much more suitable for [Text] with special characters
  /// like currency symbols.
  /// Useful in case you want to override your default [TextStyle]
  TextStyle get roboto => copyWith(fontFamily: 'Roboto');
}

extension TextStyleColorExtensions on TextStyle {
  TextStyle get opc20 => copyWith(color: color?.withOpacity(.2));

  TextStyle get opc40 => copyWith(color: color?.withOpacity(.4));

  TextStyle get opc60 => copyWith(color: color?.withOpacity(.6));

  TextStyle get opc80 => copyWith(color: color?.withOpacity(.8));

  TextStyle get white54 => copyWith(color: Colors.white54);

  TextStyle get white60 => copyWith(color: Colors.white60);

  TextStyle get white70 => copyWith(color: Colors.white70);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get black54 => copyWith(color: Colors.black54);

  TextStyle get black70 => copyWith(color: const Color(0xB3000000));

  TextStyle get black87 => copyWith(color: Colors.black87);

  TextStyle get black => copyWith(color: Colors.black);

  TextStyle primary(BuildContext context) =>
      copyWith(color: context.primaryColor);

  TextStyle secondary(BuildContext context) =>
      copyWith(color: context.secondaryColor);

  TextStyle surface(BuildContext context) =>
      copyWith(color: context.surfaceColor);

  TextStyle background(BuildContext context) =>
      copyWith(color: context.backgroundColor);

  TextStyle error(BuildContext context) => copyWith(color: context.errorColor);
}

extension TextStyleFontWeightExtensions on TextStyle {
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);

  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);

  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
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
  TextStyle get fs10 => copyWith(fontSize: 10);

  TextStyle get fs11 => copyWith(fontSize: 11);

  TextStyle get fs12 => copyWith(fontSize: 12);

  TextStyle get fs13 => copyWith(fontSize: 13);

  TextStyle get fs14 => copyWith(fontSize: 14);

  TextStyle get fs16 => copyWith(fontSize: 16);

  TextStyle get fs18 => copyWith(fontSize: 18);

  TextStyle get fs20 => copyWith(fontSize: 20);

  TextStyle get fs24 => copyWith(fontSize: 24);

  TextStyle get fs34 => copyWith(fontSize: 34);
}
