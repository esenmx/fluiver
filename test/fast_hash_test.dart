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

    group('native arithmetic', () {
      test('is deterministic', () {
        check(FastHash.fnv1a('hello')).equals(FastHash.fnv1a('hello'));
      });

      test('different inputs produce different hashes', () {
        check(FastHash.fnv1a('a')).not((it) => it.equals(FastHash.fnv1a('b')));
        final upper = FastHash.fnv1a('Hello');
        check(upper).not((it) => it.equals(FastHash.fnv1a('hello')));
      });

      test('empty string returns FNV-1a 64 offset basis', () {
        check(FastHash.fnv1a('')).equals((0xcbf29ce4 << 32) | 0x84222325);
      });

      test('known vectors are stable', () {
        // Hashes UTF-16 code units as hi/lo byte pairs, so standard FNV
        // byte vectors do not apply; pinned from the released algorithm.
        // Split literals: a >2^53 literal is a dart2js compile error.
        check(FastHash.fnv1a('a')).equals((0x08326707 << 32) | 0xb4eb37da);
        check(FastHash.fnv1a('hello')).equals((0x4ce155d4 << 32) | 0x4072f8ef);
        // Non-ASCII vectors pin the hi/lo byte split, which ASCII
        // cannot: 'é' (0xE9) exercises the >= 0x80 lo byte, and the
        // surrogate-pair '\u{1F680}' is the only class of code units
        // with a nonzero hi byte.
        check(FastHash.fnv1a('é')).equals((0x0831df07 << 32) | 0xb4ea50c2);
        check(FastHash.fnv1a('\u{1F680}'))
            .equals((0xd8ec2a88 << 32) | 0x1c1ca9b0);
      });

      test('handles unicode code units', () {
        check(FastHash.fnv1a('🚀')).not((it) => it.equals(FastHash.fnv1a('a')));
      });
    }, skip: isJS ? 'JS 53-bit integers corrupt FNV arithmetic' : false);
  });
}
