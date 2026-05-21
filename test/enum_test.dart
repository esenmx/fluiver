import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

enum _TestEnum with EnumIndexComparable { first, second, third }

void main() {
  group('EnumIndexComparable', () {
    test('greater than', () {
      check(_TestEnum.first > _TestEnum.second).isFalse();
      check(_TestEnum.second > _TestEnum.first).isTrue();
    });

    test('greater or equal', () {
      check(_TestEnum.first >= _TestEnum.second).isFalse();
      check(_TestEnum.second >= _TestEnum.second).isTrue();
      check(_TestEnum.third >= _TestEnum.second).isTrue();
    });

    test('less than', () {
      check(_TestEnum.second < _TestEnum.first).isFalse();
      check(_TestEnum.first < _TestEnum.second).isTrue();
    });

    test('less or equal', () {
      check(_TestEnum.first <= _TestEnum.second).isTrue();
      check(_TestEnum.second <= _TestEnum.second).isTrue();
      check(_TestEnum.third <= _TestEnum.second).isFalse();
    });

    test('sortable', () {
      final unordered = <_TestEnum>[.third, .first, .second];
      check(unordered..sort()).deepEquals(_TestEnum.values);
    });
  });

  group('byNameOrNull', () {
    test('matching name returns value', () {
      check(_TestEnum.values.byNameOrNull('second')).equals(.second);
    });

    test('unknown name returns null', () {
      check(_TestEnum.values.byNameOrNull('nope')).isNull();
    });

    test('?? fallback covers the missing case', () {
      final v = _TestEnum.values.byNameOrNull('nope') ?? .first;
      check(v).equals(.first);
    });
  });
}
