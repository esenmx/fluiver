import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('into', () {
    test('returns fn(this)', () {
      check(5.into((it) => it * 2)).equals(10);
      check('hello'.into((it) => it.length)).equals(5);
    });

    test('changes return type', () {
      final length = 'abc'.into((it) => it.length);
      check(length).isA<int>().equals(3);
    });

    test('chains with null-aware operator', () {
      var nullable = _maybe(null);
      check(nullable?.into((it) => it.length)).isNull();

      nullable = _maybe('hi');
      check(nullable?.into((it) => it.length)).equals(2);
    });

    test('accepts named tear-off as transform', () {
      check('42'.into(int.parse)).equals(42);
      check('abc'.into(int.tryParse)).isNull();
    });

    test('applies to extension types implementing Object', () {
      check(_UserId(7).into((id) => 'user:${id.value}')).equals('user:7');
    });
  });
}

String? _maybe(String? value) => value;

extension type _UserId(int value) implements Object;
