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

    // test('removePrefixOrNull', () {
    //   expect(''.removePrefixOrNull('foo'), null);
    //   expect('foo'.removePrefixOrNull('foo'), '');
    //   expect('foobar'.removePrefixOrNull('foo'), 'bar');
    // });

    // test('removeSuffixOrNull', () {
    //   expect(''.removeSuffixOrNull('foo'), null);
    //   expect('foo'.removeSuffixOrNull('foo'), '');
    //   expect('foobar'.removeSuffixOrNull('bar'), 'foo');
    // });

    test('safeSubstring', () {
      expect('a'.safeSubstring(2), '');
      expect('abc'.safeSubstring(0), 'abc');
      expect('abc'.safeSubstring(2, 10), 'c');
      expect('abcdef'.safeSubstring(2, 3), 'c');
    });
  });

  // group('StringSearchX', () {
  //   test('textSearch', () {
  //     expect(''.hasSearchMatch(''), isTrue);
  //     expect(''.hasSearchMatch('a'), isFalse);
  //     expect('a'.hasSearchMatch(''), isTrue);
  //     expect('Foo'.hasSearchMatch('fo'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('foo bar'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('Foo Bar'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('fo'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('f b'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('o r'), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('Baz'), isFalse);
  //     expect('Foo Bar'.hasSearchMatch('foo z'), isFalse);
  //   });

  //   test('textSearchWithSeparator', () {
  //     const sep = ',';
  //     expect('Foo'.hasSearchMatch('fo', sep), isTrue);
  //     expect('Foo,Bar'.hasSearchMatch('fo', sep), isTrue);
  //     expect('Foo Bar'.hasSearchMatch('fo', sep), isTrue);
  //     // expect('Foo Bar'.textSearch('fo b', sep), isFalse); // FIXME
  //     expect('Foo,Bar'.hasSearchMatch('fo b', sep), isTrue);
  //     expect('Foo,Bar'.hasSearchMatch('fo  b', sep), isTrue);
  //     expect('Foo,,,,Bar'.hasSearchMatch('foo bar', sep), isTrue);
  //     expect('Foo,Bar'.hasSearchMatch('Foo Bar', sep), isTrue);
  //     expect('Foo,Bar'.hasSearchMatch('ar', sep), isTrue);
  //     expect('Foo,Bar'.hasSearchMatch('z', sep), isFalse);
  //     expect('Foo,Bar'.hasSearchMatch('foo z', sep), isFalse);
  //   });
  // });
}
