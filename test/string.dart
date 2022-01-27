import 'package:dashx/src/string.dart';
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
      expect('Dart,Go', 'dart,go'.splitCapitalizeAll(','));
    });

    test('isEmptyOrNull', () {
      expect(''.isEmptyOrNull, null.isEmptyOrNull);
    });

    test('isEmptyNullable', () {
      expect(true, ''.isEmptyNullable);
      expect(false, null.isEmptyNullable);
      expect(false, 'go'.isEmptyNullable);
    });

    test('isNotEmptyNullable', () {
      expect(true, 'dart'.isNotEmptyNullable);
      expect(false, ''.isNotEmptyNullable);
      expect(false, null.isNotEmptyNullable);
    });

    test('tryParseDateTime', () {
      expect(null.tryParseDateTime, null);
      expect(''.tryParseDateTime, null);
      expect('1990-06-26'.tryParseDateTime, DateTime(1990, 6, 26));
    });

    test('tryParseHexColor', () {
      expect(''.tryParseHexColor, null);
      expect('asd'.tryParseHexColor, null);
      expect('#26ab1f'.tryParseHexColor, Color(0xff26ab1f));
      expect('ff26ab1f'.tryParseHexColor, Color(0xff26ab1f));
      expect('0xff26ab1f'.tryParseHexColor, Color(0xff26ab1f));
    });
  });
}
