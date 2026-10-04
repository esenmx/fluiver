import 'dart:math' as math;
import 'dart:ui' show ColorSpace;

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double lightnessOf(Color color) => HSLColor.fromColor(color).lightness;

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void _checkChannelsClose(Color actual, Color expected, String reason) {
  check(actual.r, because: reason).isCloseTo(expected.r, 1 / 255);
  check(actual.g, because: reason).isCloseTo(expected.g, 1 / 255);
  check(actual.b, because: reason).isCloseTo(expected.b, 1 / 255);
}

void main() {
  group('darken', () {
    test('default amount lowers HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);

      final darkened = lightnessOf(blue.darken());
      check(darkened).isCloseTo(lightnessOf(blue) - 0.1, 1e-6);
    });

    test('custom amount darkens further', () {
      const c = Color(0xFF888888);

      check(lightnessOf(c.darken(0.4))).isLessThan(lightnessOf(c));
    });

    test('clamps amount to [0, 1]', () {
      const c = Color(0xFF888888);

      check(lightnessOf(c.darken(-1))).equals(lightnessOf(c));
      check(lightnessOf(c.darken(2))).equals(0);
    });

    test('clamps result lightness to [0, 1]', () {
      check(lightnessOf(Colors.black.darken())).equals(0);
    });
  });

  group('lighten', () {
    test('default amount raises HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);

      final lightened = lightnessOf(blue.lighten());
      check(lightened).isCloseTo(lightnessOf(blue) + 0.1, 1e-6);
    });

    test('clamps result lightness to [0, 1]', () {
      check(lightnessOf(Colors.white.lighten())).equals(1);
    });
  });

  group('contrastText', () {
    test('returns white over dark background', () {
      check(Colors.black.contrastText).equals(Colors.white);
      check(const Color(0xFF1F1F1F).contrastText).equals(Colors.white);
    });

    test('returns black over light background', () {
      check(Colors.white.contrastText).equals(Colors.black);
      check(const Color(0xFFEEEEEE).contrastText).equals(Colors.black);
    });

    test('picks the higher-contrast of black/white', () {
      for (final bg in const [
        Color(0xFF808080), // mid gray, luminance ~0.216
        Color(0xFF2196F3), // Colors.blue[500], luminance ~0.29
        Color(0xFFE91E63), // Colors.pink[500]
        Color(0xFF4CAF50), // Colors.green[500]
      ]) {
        final best = _contrast(bg, Colors.black) >= _contrast(bg, Colors.white)
            ? Colors.black
            : Colors.white;
        check(
          bg.contrastText,
          because:
              'bg=$bg lum=${bg.computeLuminance().toStringAsFixed(3)} '
              'black=${_contrast(bg, Colors.black).toStringAsFixed(2)} '
              'white=${_contrast(bg, Colors.white).toStringAsFixed(2)}',
        ).equals(best);
      }
    });
  });

  group('lightness shift', () {
    test('darken(0) keeps a Display-P3 color space', () {
      const p3 = Color.from(
        alpha: 1,
        red: 1,
        green: 0,
        blue: 0,
        colorSpace: ColorSpace.displayP3,
      );
      check(p3.darken(0).colorSpace).equals(ColorSpace.displayP3);
    });

    test('darken(0) preserves sub-8-bit precision', () {
      const c = Color.from(alpha: 0.5, red: 0.3, green: 0.5, blue: 0.7);
      final out = c.darken(0);
      check(out.a).isCloseTo(c.a, 1e-6);
      check(out.r).isCloseTo(c.r, 1e-6);
    });

    test('darken/lighten match HSLColor within 1/255 across primaries', () {
      for (final swatch in Colors.primaries) {
        for (final shade in const [100, 300, 500, 700, 900]) {
          final c = swatch[shade] ?? swatch;
          final hsl = HSLColor.fromColor(c);
          final l = hsl.lightness;
          for (final amount in const [.05, .1, .3]) {
            final darker = hsl.withLightness((l - amount).clamp(0.0, 1.0));
            final lighter = hsl.withLightness((l + amount).clamp(0.0, 1.0));
            _checkChannelsClose(
              c.darken(amount),
              darker.toColor(),
              'darken $c by $amount',
            );
            _checkChannelsClose(
              c.lighten(amount),
              lighter.toColor(),
              'lighten $c by $amount',
            );
          }
        }
      }
    });
  });
}
