import 'package:dashx/dashx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('String', () {
    test('capitalize', () {
      expect('', ''.capitalize);
      expect('A', 'a'.capitalize);
      expect('Dashx', 'dashx'.capitalize);
    });

    test('capitalizeEach', () {
      expect('', ''.capitalizeEach());
      expect('A', 'a'.capitalizeEach());
      expect('Dart Go', 'dart go'.capitalizeEach());
      expect('Dart,Go', 'dart,,go'.capitalizeEach(','));
    });

    test('removePrefixOrNull', () {
      expect(null, ''.removePrefixOrNull('foo'));
      expect('', 'foo'.removePrefixOrNull('foo'));
      expect('bar', 'foobar'.removePrefixOrNull('foo'));
    });

    test('safeRemovePrefix', () {
      expect('', ''.safeRemovePrefix('foo'));
      expect('', 'foo'.safeRemovePrefix('foo'));
      expect('bar', 'foobar'.safeRemovePrefix('foo'));
    });

    test('removeSuffixOrNull', () {
      expect(null, ''.removeSuffixOrNull('foo'));
      expect('', 'foo'.removeSuffixOrNull('foo'));
      expect('foo', 'foobar'.removeSuffixOrNull('bar'));
    });

    test('safeRemoveSuffix', () {
      expect('', ''.safeRemoveSuffix('foo'));
      expect('', 'foo'.safeRemoveSuffix('foo'));
      expect('foo', 'foobar'.safeRemoveSuffix('bar'));
    });
  });
}
