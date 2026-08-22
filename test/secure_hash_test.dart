import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureHash.sha256', () {
    test('is deterministic', () {
      check(SecureHash.sha256('hello')).equals(SecureHash.sha256('hello'));
    });

    test('different inputs produce different hashes', () {
      check(
        SecureHash.sha256('a'),
      ).not((it) => it.equals(SecureHash.sha256('b')));
      final upper = SecureHash.sha256('Hello');
      check(upper).not((it) => it.equals(SecureHash.sha256('hello')));
    });

    test('empty string returns correct SHA-256 hash', () {
      check(SecureHash.sha256('')).equals(
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
    });

    test('handles unicode code units', () {
      check(
        SecureHash.sha256('🚀'),
      ).not((it) => it.equals(SecureHash.sha256('a')));
    });
  });
}
