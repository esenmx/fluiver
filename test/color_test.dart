import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

double lightnessOf(Color color) => HSLColor.fromColor(color).lightness;

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

extension on Subject<Color> {
  void channelsCloseTo(Color expected, String reason) {
    has('$reason.r', (c) => c.r).isCloseTo(expected.r, 1 / 255);
    has('$reason.g', (c) => c.g).isCloseTo(expected.g, 1 / 255);
    has('$reason.b', (c) => c.b).isCloseTo(expected.b, 1 / 255);
  }
}

void main() {
  group('darker', () {
    test('default amount lowers HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);

      final lowered = lightnessOf(blue.darker());
      check(lowered).isCloseTo(lightnessOf(blue) - 0.1, 1e-6);
    });

    test('custom amount lowers lightness further', () {
      const c = Color(0xFF888888);

      check(lightnessOf(c.darker(0.4))).isLessThan(lightnessOf(c));
    });

    test('amount 1 reaches black', () {
      check(lightnessOf(const Color(0xFF888888).darker(1))).equals(0);
    });

    test('clamps result lightness to [0, 1]', () {
      check(lightnessOf(Colors.black.darker())).equals(0);
    });

    test('throws RangeError when amount is outside [0, 1] or NaN', () {
      for (final amount in const [-0.3, -1.0, 1.01, 5.0, double.nan]) {
        check(
          because: '$amount',
          () => Colors.blue.darker(amount),
        ).throws<RangeError>().has('name', (e) => e.name).equals('amount');
      }
    });
  });

  group('lighter', () {
    test('default amount raises HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);

      final raised = lightnessOf(blue.lighter());
      check(raised).isCloseTo(lightnessOf(blue) + 0.1, 1e-6);
    });

    test('amount 1 reaches white', () {
      check(lightnessOf(const Color(0xFF888888).lighter(1))).equals(1);
    });

    test('clamps result lightness to [0, 1]', () {
      check(lightnessOf(Colors.white.lighter())).equals(1);
    });

    test('throws RangeError when amount is outside [0, 1] or NaN', () {
      for (final amount in const [-0.5, -1.0, 1.01, 10.0, double.nan]) {
        check(
          because: '$amount',
          () => Colors.blue.lighter(amount),
        ).throws<RangeError>().has('name', (e) => e.name).equals('amount');
      }
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
      const midGrey = Color(0xFF808080);
      for (final bg in const [
        midGrey,
        Colors.blue,
        Colors.pink,
        Colors.green,
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

    test('in-range extendedSRGB picks what its sRGB twin picks', () {
      for (final channel in const [0.0, 0.1, 0.18, 0.2, 0.5, 0.9, 1.0]) {
        final twin = Color.from(
          alpha: 1,
          red: channel,
          green: channel,
          blue: channel,
        );
        final wide = Color.from(
          alpha: 1,
          red: channel,
          green: channel,
          blue: channel,
          colorSpace: .extendedSRGB,
        );
        check(because: '$channel', wide.contrastText).equals(twin.contrastText);
      }
    });

    test('throws ArgumentError when a channel is outside [0, 1]', () {
      for (final (red, green, blue) in const [
        (1.5, 0.5, 0.5),
        (-0.2, 0.5, 1.0),
        (0.5, double.nan, 0.5),
      ]) {
        final wide = Color.from(
          alpha: 1,
          red: red,
          green: green,
          blue: blue,
          colorSpace: .extendedSRGB,
        );
        check(
          because: '($red, $green, $blue)',
          () => wide.contrastText,
        ).throws<ArgumentError>();
      }
    });
  });

  group('lightness shift', () {
    test('darker(0) keeps a Display-P3 color space', () {
      const p3 = Color.from(
        alpha: 1,
        red: 1,
        green: 0,
        blue: 0,
        colorSpace: .displayP3,
      );
      check(p3.darker(0).colorSpace).equals(.displayP3);
    });

    test('darker(0) preserves sub-8-bit precision', () {
      const c = Color.from(alpha: 0.5, red: 0.3, green: 0.5, blue: 0.7);
      final out = c.darker(0);
      check(out.a).isCloseTo(c.a, 1e-6);
      check(out.r).isCloseTo(c.r, 1e-6);
    });

    test('throws ArgumentError when a channel is outside [0, 1]', () {
      const outOfRange = [
        (1.5, 0.5, 0.5),
        (2.0, 1.0, 1.0),
        (-0.2, 0.5, 1.0),
        (0.5, double.nan, 0.5),
      ];
      for (final (red, green, blue) in outOfRange) {
        final wide = Color.from(
          alpha: 1,
          red: red,
          green: green,
          blue: blue,
          colorSpace: .extendedSRGB,
        );
        for (final (name, shift) in <(String, Color Function())>[
          ('darker', wide.darker),
          ('lighter', wide.lighter),
          ('darker(0)', () => wide.darker(0)),
        ]) {
          check(
            because: '$name ($red, $green, $blue)',
            shift,
          ).throws<ArgumentError>();
        }
      }
    });

    test('in-range extendedSRGB channels shift and keep the color space', () {
      const inRange = Color.from(
        alpha: 1,
        red: 1,
        green: 0.5,
        blue: 0.5,
        colorSpace: .extendedSRGB,
      );
      final darker = inRange.darker();
      check(darker.colorSpace).equals(.extendedSRGB);
      check(darker).channelsCloseTo(
        HSLColor.fromColor(const .from(alpha: 1, red: 1, green: 0.5, blue: 0.5))
            .withLightness(0.65)
            .toColor(),
        'darker',
      );
    });

    test('both match HSLColor within 1/255 across primaries', () {
      for (final swatch in Colors.primaries) {
        for (final shade in const [100, 300, 500, 700, 900]) {
          final c = swatch[shade] ?? swatch;
          final hsl = HSLColor.fromColor(c);
          final l = hsl.lightness;
          for (final amount in const [.05, .1, .3]) {
            final darker = hsl.withLightness((l - amount).clamp(0.0, 1.0));
            final lighter = hsl.withLightness((l + amount).clamp(0.0, 1.0));
            check(c.darker(amount))
                .channelsCloseTo(darker.toColor(), 'darker $c by $amount');
            check(c.lighter(amount))
                .channelsCloseTo(lighter.toColor(), 'lighter $c by $amount');
          }
        }
      }
    });
  });
}
