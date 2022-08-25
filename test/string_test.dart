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

    test('initialsLast - capitalizeLowerLatter', () {
      expect(''.initialsWithLast(), '');
      expect('    '.initialsWithLast(), '');
      expect('foo'.initialsWithLast(), 'Foo');
      expect('fOO'.initialsWithLast(), 'Foo');
      expect('John Doe'.initialsWithLast(), 'J. Doe');
      expect('jOHN doe'.initialsWithLast(), 'J. Doe');
      expect('j dOE'.initialsWithLast(), 'J. Doe');
      expect('john j dOE'.initialsWithLast(), 'J. J. Doe');
      expect('john  j dOE'.initialsWithLast(), 'J. J. Doe');
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

    test('safeSubstring', () {
      expect('a'.safeSubstring(2), '');
      expect('abc'.safeSubstring(0), 'abc');
      expect('abc'.safeSubstring(2, 10), 'c');
      expect('abcdef'.safeSubstring(2, 3), 'c');
    });
  });

  group('StringSearchX', () {
    test('textSearch', () {
      expect(''.textSearch(''), isTrue);
      expect(''.textSearch('a'), isFalse);
      expect('a'.textSearch(''), isTrue);
      expect('Foo'.textSearch('fo'), isTrue);
      expect('Foo Bar'.textSearch('foo bar'), isTrue);
      expect('Foo Bar'.textSearch('Foo Bar'), isTrue);
      expect('Foo Bar'.textSearch('fo'), isTrue);
      expect('Foo Bar'.textSearch('f b'), isTrue);
      expect('Foo Bar'.textSearch('o r'), isTrue);
      expect('Foo Bar'.textSearch('Baz'), isFalse);
      expect('Foo Bar'.textSearch('foo z'), isFalse);
    });

    test('textSearchWithSeparator', () {
      const sep = ',';
      expect('Foo'.textSearch('fo', sep), isTrue);
      expect('Foo,Bar'.textSearch('fo', sep), isTrue);
      expect('Foo Bar'.textSearch('fo', sep), isTrue);
      // expect('Foo Bar'.textSearch('fo b', sep), isFalse); // FIXME
      expect('Foo,Bar'.textSearch('fo b', sep), isTrue);
      expect('Foo,Bar'.textSearch('fo  b', sep), isTrue);
      expect('Foo,,,,Bar'.textSearch('foo bar', sep), isTrue);
      expect('Foo,Bar'.textSearch('Foo Bar', sep), isTrue);
      expect('Foo,Bar'.textSearch('ar', sep), isTrue);
      expect('Foo,Bar'.textSearch('z', sep), isFalse);
      expect('Foo,Bar'.textSearch('foo z', sep), isFalse);
    });
  });
}
