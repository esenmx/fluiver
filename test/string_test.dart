import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('String', () {
    test('capitalize', () {
      expect(''.capitalize, '');
      expect('a'.capitalize, 'A');
      expect('foo'.capitalize, 'Foo');
    });

    test('capitalizeEach', () {
      expect(''.capitalizeEach(), '');
      expect(''.capitalizeEach('', '-'), '');
      expect('a'.capitalizeEach(), 'A');
      expect('foo bar'.capitalizeEach(), 'Foo Bar');
      expect('foo,,bar'.capitalizeEach(','), 'Foo,Bar');
      expect('foo,,bar'.capitalizeEach(',', ' '), 'Foo Bar');
    });

    test('shortPersonalName - capitalizeLowerLatter', () {
      expect(''.shortPersonalName(), '');
      expect('    '.shortPersonalName(), '');
      expect('foo'.shortPersonalName(), 'Foo');
      expect('fOO'.shortPersonalName(), 'Foo');
      expect('John Doe'.shortPersonalName(), 'J. Doe');
      expect('jOHN doe'.shortPersonalName(), 'J. Doe');
      expect('j dOE'.shortPersonalName(), 'J Doe');
      expect('john j dOE'.shortPersonalName(), 'J. J Doe');
      expect('john  j dOE'.shortPersonalName(), 'J. J Doe');
    });

    test('removePrefixOrNull', () {
      expect(''.removePrefixOrNull('foo'), null);
      expect('foo'.removePrefixOrNull('foo'), '');
      expect('foobar'.removePrefixOrNull('foo'), 'bar');
    });

    test('removePrefixOrElse', () {
      expect(''.removePrefixOrElse('foo'), '');
      expect('foo'.removePrefixOrElse('foo'), '');
      expect('foo'.removePrefixOrElse('baz', (s) => s.toUpperCase()), 'FOO');
      expect('foobar'.removePrefixOrElse('foo'), 'bar');
    });

    test('removeSuffixOrNull', () {
      expect(''.removeSuffixOrNull('foo'), null);
      expect('foo'.removeSuffixOrNull('foo'), '');
      expect('foobar'.removeSuffixOrNull('bar'), 'foo');
    });

    test('removeSuffixOrElse', () {
      expect(''.removeSuffixOrElse('foo'), '');
      expect('foo'.removeSuffixOrElse('foo'), '');
      expect('foo'.removeSuffixOrElse('baz', (s) => s.toUpperCase()), 'FOO');
      expect('foobar'.removeSuffixOrElse('bar'), 'foo');
    });
  });
}
