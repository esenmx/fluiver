part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Applying colors to [TextStyle].
extension TextStyleColor on TextStyle {
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withValues(alpha: opacity));
  }

  TextStyle withColor(Color color) => copyWith(color: color);

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
    return copyWith(color: context._cs.primary);
  }

  TextStyle withSecondaryColor(BuildContext context) {
    return copyWith(color: context._cs.secondary);
  }

  TextStyle withTertiaryColor(BuildContext context) {
    return copyWith(color: context._cs.tertiary);
  }

  TextStyle withSurfaceColor(BuildContext context) {
    return copyWith(color: context._cs.surface);
  }

  TextStyle withOnSurfaceColor(BuildContext context) {
    return copyWith(color: context._cs.onSurface);
  }

  TextStyle withErrorColor(BuildContext context) {
    return copyWith(color: context._cs.error);
  }
}

/// {@macro extensionFor}
/// Applying font weights to [TextStyle].
extension TextStyleFontWeight on TextStyle {
  TextStyle get withWeight100 => copyWith(fontWeight: .w100);
  TextStyle get withWeight200 => copyWith(fontWeight: .w200);
  TextStyle get withWeight300 => copyWith(fontWeight: .w300);
  TextStyle get withWeight400 => copyWith(fontWeight: .w400);
  TextStyle get withWeight500 => copyWith(fontWeight: .w500);
  TextStyle get withWeight600 => copyWith(fontWeight: .w600);
  TextStyle get withWeight700 => copyWith(fontWeight: .w700);
  TextStyle get withWeight800 => copyWith(fontWeight: .w800);
  TextStyle get withWeight900 => copyWith(fontWeight: .w900);
}

/// {@macro extensionFor}
/// Applying text decorations to [TextStyle].
extension TextStyleDecoration on TextStyle {
  TextStyle get withUnderline => copyWith(decoration: .underline);
  TextStyle get withOverline => copyWith(decoration: .overline);
  TextStyle get withLineThrough => copyWith(decoration: .lineThrough);
}

/// {@macro extensionFor}
/// Setting font size on [TextStyle].
extension TextStyleSize on TextStyle {
  TextStyle withSize(double size) => copyWith(fontSize: size);
}
