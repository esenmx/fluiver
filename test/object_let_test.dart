import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('let', () {
    test('returns fn(this)', () {
      check(5.let((it) => it * 2)).equals(10);
      check('hello'.let((it) => it.length)).equals(5);
    });

    test('changes return type', () {
      final length = 'abc'.let((it) => it.length);
      check(length).isA<int>().equals(3);
    });

    test('chains with null-aware operator', () {
      var nullable = _maybe(null);
      check(nullable?.let((it) => it.length)).isNull();

      nullable = _maybe('hi');
      check(nullable?.let((it) => it.length)).equals(2);
    });

    test('accepts named tear-off as transform', () {
      check('42'.let(int.parse)).equals(42);
      check('abc'.let(int.tryParse)).isNull();
    });
  });
}

String? _maybe(String? value) => value;
