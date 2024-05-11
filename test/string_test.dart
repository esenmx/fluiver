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
      expect(''.capitalizeAll(), '');
      expect(''.capitalizeAll(separator: '', joiner: '-'), '');
      expect('a'.capitalizeAll(), 'A');
      expect('foo bar'.capitalizeAll(), 'Foo Bar');
      expect('foo,,bar'.capitalizeAll(separator: ','), 'Foo,Bar');
      expect('foo,,bar'.capitalizeAll(separator: ',', joiner: ' '), 'Foo Bar');
    });

    test('safeSubstring', () {
      expect('a'.safeSubstring(2), '');
      expect('abc'.safeSubstring(0), 'abc');
      expect('abc'.safeSubstring(2, 10), 'c');
      expect('abcdef'.safeSubstring(2, 3), 'c');
    });
  });
}
