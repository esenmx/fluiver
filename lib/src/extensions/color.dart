part of '../../fluiver.dart';

/// HSL-based [Color] transforms and contrast-text picker.
extension ColorTransform on Color {
  /// Returns a darker variant by subtracting [amount] from HSL lightness.
  ///
  /// [amount] is clamped to `[0, 1]`. Default `0.1` (10% darker).
  ///
  /// ```dart
  /// final pressed = Theme.of(context).colorScheme.primary.darken();
  /// ```
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount.clamp(0.0, 1.0)).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Returns a lighter variant by adding [amount] to HSL lightness.
  ///
  /// [amount] is clamped to `[0, 1]`. Default `0.1` (10% lighter).
  ///
  /// ```dart
  /// final hover = Theme.of(context).colorScheme.primary.lighten();
  /// ```
  Color lighten([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount.clamp(0.0, 1.0)).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Returns [Colors.black] or [Colors.white] — whichever has more
  /// contrast against this color via [Color.computeLuminance].
  ///
  /// Use as a foreground text color over an arbitrary background:
  ///
  /// ```dart
  /// Container(
  ///   color: tagColor,
  ///   child: Text(label, style: TextStyle(color: tagColor.contrastText)),
  /// )
  /// ```
  Color get contrastText {
    return computeLuminance() > .5 ? Colors.black : Colors.white;
  }
}
