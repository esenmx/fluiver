import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double lightnessOf(Color color) => HSLColor.fromColor(color).lightness;

void main() {
  group('darken', () {
    test('default amount lowers HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);

      check(
        lightnessOf(blue.darken()),
      ).isCloseTo(lightnessOf(blue) - 0.1, 1e-6);
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

      check(
        lightnessOf(blue.lighten()),
      ).isCloseTo(lightnessOf(blue) + 0.1, 1e-6);
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
  });
}
