import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('darken', () {
    test('default amount lowers HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);
      final original = HSLColor.fromColor(blue).lightness;

      final darker = HSLColor.fromColor(blue.darken()).lightness;

      check(darker).isCloseTo(original - 0.1, 1e-6);
    });

    test('custom amount darkens further', () {
      const c = Color(0xFF888888);
      final l = HSLColor.fromColor(c.darken(0.4)).lightness;

      check(l).isLessThan(HSLColor.fromColor(c).lightness);
    });

    test('clamps amount to [0, 1]', () {
      const c = Color(0xFF888888);

      check(
        HSLColor.fromColor(c.darken(-1)).lightness,
      ).equals(HSLColor.fromColor(c).lightness);
      check(HSLColor.fromColor(c.darken(2)).lightness).equals(0);
    });

    test('clamps result lightness to [0, 1]', () {
      check(HSLColor.fromColor(Colors.black.darken()).lightness).equals(0);
    });
  });

  group('lighten', () {
    test('default amount raises HSL lightness by 0.1', () {
      const blue = Color(0xFF2196F3);
      final original = HSLColor.fromColor(blue).lightness;

      final lighter = HSLColor.fromColor(blue.lighten()).lightness;

      check(lighter).isCloseTo(original + 0.1, 1e-6);
    });

    test('clamps result lightness to [0, 1]', () {
      check(HSLColor.fromColor(Colors.white.lighten()).lightness).equals(1);
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
