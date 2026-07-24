import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FastHash.fnv1a', () {
    test('is deterministic', () {
      check(FastHash.fnv1a('hello')).equals(FastHash.fnv1a('hello'));
    });

    test('different inputs produce different hashes', () {
      check(FastHash.fnv1a('a')).not((it) => it.equals(FastHash.fnv1a('b')));
      final upper = FastHash.fnv1a('Hello');
      check(upper).not((it) => it.equals(FastHash.fnv1a('hello')));
    });

    test('empty string returns FNV-1a 64 offset basis', () {
      check(FastHash.fnv1a('')).equals(0xcbf29ce484222325);
    });

    test('handles unicode code units', () {
      check(FastHash.fnv1a('🚀')).not((it) => it.equals(FastHash.fnv1a('a')));
    });
  });
}
