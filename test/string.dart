import 'package:dashx/dashx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('String', () {
    test('capitalize', () {
      expect('', ''.capitalize);
      expect('A', 'a'.capitalize);
      expect('Dashx', 'dashx'.capitalize);
    });

    test('splitCapitalizeAll', () {
      expect('', ''.splitCapitalizeAll());
      expect('A', 'a'.splitCapitalizeAll());
      expect('Dart Go', 'dart go'.splitCapitalizeAll());
      expect('Dart,Go', 'dart,,go'.splitCapitalizeAll(','));
    });

    test('isEmptyOrNull', () {
      expect(''.isEmptyOrNull, null.isEmptyOrNull);
    });

    test('isEmptyTrue', () {
      expect(true, ''.isEmptyTrue);
      expect(false, null.isEmptyTrue);
      expect(false, 'go'.isEmptyTrue);
    });

    test('isNotEmptyTrue', () {
      expect(true, 'dart'.isNotEmptyTrue);
      expect(false, ''.isNotEmptyTrue);
      expect(false, null.isNotEmptyTrue);
    });

    test('tryParseDateTime', () {
      expect(null.tryParseDateTime, null);
      expect(''.tryParseDateTime, null);
      expect('1990-06-26'.tryParseDateTime, DateTime(1990, 6, 26));
    });

    test('tryParseHexColor', () {
      expect(''.tryParseHexColor, null);
      expect('asd'.tryParseHexColor, null);
      expect('#7c4dff'.tryParseHexColor, const Color(0xff7c4dff));
      expect('ff7c4dff'.tryParseHexColor, const Color(0xff7c4dff));
      expect('0xff7c4dff'.tryParseHexColor, const Color(0xff7c4dff));
    });
  });
}
