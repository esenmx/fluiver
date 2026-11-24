/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'dart:math' as math;
import 'dart:ui';

/// HSL-based [Color] transforms and contrast-text picker.
extension ColorTransform on Color {
  /// Returns a darker variant: [amount] subtracted from HSL lightness, hue and
  /// saturation kept; lightness stops at 0 (black).
  ///
  /// [amount] is on the `[0, 1]` lightness scale of [HSLColor.lightness], not a
  /// percentage: `0.1` (the default) lowers lightness by a tenth, `1` always
  /// gives black.
  /// Throws [RangeError] if [amount] is outside `[0, 1]` or `NaN`, and
  /// [ArgumentError] if a channel is outside `[0, 1]` (extended sRGB): map
  /// such a color into gamut first.
  ///
  /// ```dart
  /// final pressed = Theme.of(context).colorScheme.primary.darker();
  /// ```
  Color darker([double amount = .1]) =>
      _withLightnessShift(-_checkAmount(amount));

  /// Returns a lighter variant: [amount] added to HSL lightness, hue and
  /// saturation kept; lightness stops at 1 (white).
  ///
  /// [amount] is on the `[0, 1]` lightness scale of [HSLColor.lightness], not a
  /// percentage: `0.1` (the default) raises lightness by a tenth, `1` always
  /// gives white.
  /// Throws [RangeError] if [amount] is outside `[0, 1]` or `NaN`, and
  /// [ArgumentError] if a channel is outside `[0, 1]` (extended sRGB): map
  /// such a color into gamut first.
  ///
  /// ```dart
  /// final hover = Theme.of(context).colorScheme.primary.lighter();
  /// ```
  Color lighter([double amount = .1]) =>
      _withLightnessShift(_checkAmount(amount));

  /// [Colors.black] or [Colors.white], whichever has the higher WCAG contrast
  /// ratio against this color.
  ///
  /// Use as a foreground text color over an arbitrary background:
  ///
  /// ```dart
  /// Container(
  ///   color: tagColor,
  ///   child: Text(label, style: TextStyle(color: tagColor.contrastText)),
  /// )
  /// ```
  ///
  /// Throws [ArgumentError] if a channel is outside `[0, 1]` (extended sRGB):
  /// map such a color into gamut first.
  Color get contrastText {
    _checkChannels();
    // computeLuminance asserts against extendedSRGB; in-range channels mean
    // the same in plain sRGB.
    final luminance =
        (colorSpace == .extendedSRGB ? withValues(colorSpace: .sRGB) : this)
            .computeLuminance();
    final againstBlack = (luminance + .05) / .05;
    final againstWhite = 1.05 / (luminance + .05);
    return againstBlack >= againstWhite
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
  }

  void _checkChannels() {
    for (final channel in [r, g, b]) {
      if (!(channel >= 0 && channel <= 1)) {
        throw ArgumentError.value(
          this,
          'color',
          'has a channel outside [0, 1]; map it into gamut first',
        );
      }
    }
  }

  static double _checkAmount(double amount) {
    if (!(amount >= 0 && amount <= 1)) {
      throw RangeError.value(amount, 'amount', 'must be within [0, 1]');
    }
    return amount;
  }

  // HSL shift at fixed hue/saturation on double channels: keeps precision and
  // colorSpace.
  Color _withLightnessShift(double delta) {
    _checkChannels();
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final lightness = (max + min) / 2;
    final target = (lightness + delta).clamp(0.0, 1.0);
    final span = 1 - (2 * lightness - 1).abs();
    final scale = span == 0 ? 0.0 : (1 - (2 * target - 1).abs()) / span;
    double shift(double c) =>
        (target + (c - lightness) * scale).clamp(0.0, 1.0);
    return .from(
      alpha: a,
      red: shift(r),
      green: shift(g),
      blue: shift(b),
      colorSpace: colorSpace,
    );
  }
}
