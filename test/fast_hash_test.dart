import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FastHash.fnv1a', () {
    const isJS = kIsWeb && !kIsWasm;

    test('throws UnsupportedError on JS web', () {
      check(() => FastHash.fnv1a('hello'))
          .throws<UnsupportedError>()
          .has((e) => e.message, 'message')
          .isNotNull()
          .contains('FastHash.fnv1a needs 64-bit ints');
    }, skip: !isJS);

    group(
      'native arithmetic',
      () {
        test('is deterministic', () {
          check(FastHash.fnv1a('hello')).equals(FastHash.fnv1a('hello'));
        });

        test('different inputs produce different hashes', () {
          check(
            FastHash.fnv1a('a'),
          ).not((it) => it.equals(FastHash.fnv1a('b')));
          final upper = FastHash.fnv1a('Hello');
          check(upper).not((it) => it.equals(FastHash.fnv1a('hello')));
        });

        test('empty string returns FNV-1a 64 offset basis', () {
          check(FastHash.fnv1a('')).equals((0xcbf29ce4 << 32) | 0x84222325);
        });

        test('handles unicode code units', () {
          check(
            FastHash.fnv1a('🚀'),
          ).not((it) => it.equals(FastHash.fnv1a('a')));
        });
      },
      skip: isJS ? 'JS 53-bit integers corrupt FNV arithmetic' : false,
    );
  });
}
