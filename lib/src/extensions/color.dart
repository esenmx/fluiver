import 'dart:math' as math;

import 'package:flutter/material.dart';

/// HSL-based [Color] transforms and contrast-text picker.
extension ColorTransform on Color {
  /// Returns a darker variant by subtracting [amount] from HSL lightness.
  ///
  /// [amount] is clamped to `[0, 1]`. Default `0.1` (10% darker).
  ///
  /// ```dart
  /// final pressed = Theme.of(context).colorScheme.primary.darken();
  /// ```
  Color darken([double amount = .1]) =>
      _withLightnessShift(-amount.clamp(0.0, 1.0));

  /// Returns a lighter variant by adding [amount] to HSL lightness.
  ///
  /// [amount] is clamped to `[0, 1]`. Default `0.1` (10% lighter).
  ///
  /// ```dart
  /// final hover = Theme.of(context).colorScheme.primary.lighten();
  /// ```
  Color lighten([double amount = .1]) =>
      _withLightnessShift(amount.clamp(0.0, 1.0));

  /// Returns [Colors.black] or [Colors.white] — whichever has the higher
  /// WCAG contrast ratio against this color.
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
    final luminance = computeLuminance();
    final againstBlack = (luminance + .05) / .05;
    final againstWhite = 1.05 / (luminance + .05);
    return againstBlack >= againstWhite ? Colors.black : Colors.white;
  }

  // HSL shift at fixed hue/saturation on double channels: keeps precision and
  // colorSpace.
  Color _withLightnessShift(double delta) {
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final lightness = (max + min) / 2;
    final target = (lightness + delta).clamp(0.0, 1.0);
    final span = 1 - (2 * lightness - 1).abs();
    final scale = span == 0 ? 0.0 : (1 - (2 * target - 1).abs()) / span;
    double shift(double c) =>
        (target + (c - lightness) * scale).clamp(0.0, 1.0);
    return Color.from(
      alpha: a,
      red: shift(r),
      green: shift(g),
      blue: shift(b),
      colorSpace: colorSpace,
    );
  }
}
