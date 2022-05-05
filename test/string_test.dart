import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('String', () {
    test('capitalize', () {
      expect('', ''.capitalize);
      expect('A', 'a'.capitalize);
      expect('Fluiver', 'fluiver'.capitalize);
    });

    test('capitalizeEach', () {
      expect('', ''.capitalizeEach());
      expect('A', 'a'.capitalizeEach());
      expect('Dart Go', 'dart go'.capitalizeEach());
      expect('Dart,Go', 'dart,,go'.capitalizeEach(','));
    });

    test('nameAbbreviation', () {
      expect('', ''.nameAbbreviation());
      expect('Asd', 'asd'.nameAbbreviation());
      expect('John Doe'.nameAbbreviation(), 'J. Doe');
      expect('john doe'.nameAbbreviation(), 'J. Doe');
    });

    test('removePrefixOrNull', () {
      expect(null, ''.removePrefixOrNull('foo'));
      expect('', 'foo'.removePrefixOrNull('foo'));
      expect('bar', 'foobar'.removePrefixOrNull('foo'));
    });

    test('mayRemovePrefix', () {
      expect('', ''.mayRemovePrefix('foo'));
      expect('', 'foo'.mayRemovePrefix('foo'));
      expect('bar', 'foobar'.mayRemovePrefix('foo'));
    });

    test('removeSuffixOrNull', () {
      expect(null, ''.removeSuffixOrNull('foo'));
      expect('', 'foo'.removeSuffixOrNull('foo'));
      expect('foo', 'foobar'.removeSuffixOrNull('bar'));
    });

    test('mayRemoveSuffix', () {
      expect('', ''.mayRemoveSuffix('foo'));
      expect('', 'foo'.mayRemoveSuffix('foo'));
      expect('foo', 'foobar'.mayRemoveSuffix('bar'));
    });
  });
}
