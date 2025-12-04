import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('capitalize', () {
    test('empty string', () => check(''.capitalize).equals(''));
    test('single char', () => check('a'.capitalize).equals('A'));
    test('word', () => check('foo'.capitalize).equals('Foo'));
  });

  group('capitalizeAll', () {
    test('empty', () => check(''.capitalizeAll()).equals(''));
    test('single', () => check('a'.capitalizeAll()).equals('A'));
    test(
      'multiple words',
      () => check('foo bar'.capitalizeAll()).equals('Foo Bar'),
    );
    test('custom separator', () {
      check('foo,,bar'.capitalizeAll(separator: ',')).equals('Foo,Bar');
    });
    test('custom joiner', () {
      check('foo,,bar'.capitalizeAll(separator: ',', joiner: ' '))
          .equals('Foo Bar');
    });
  });

  group('safeSubstring', () {
    test('start beyond length', () => check('a'.safeSubstring(2)).equals(''));
    test('full string', () => check('abc'.safeSubstring(0)).equals('abc'));
    test(
      'end beyond length',
      () => check('abc'.safeSubstring(2, 10)).equals('c'),
    );
    test('normal range', () => check('abcdef'.safeSubstring(2, 3)).equals('c'));
  });
}
