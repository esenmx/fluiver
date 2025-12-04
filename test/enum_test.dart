import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

enum _TestEnum with EnumIndexComparable { foo, bar, baz }

void main() {
  group('EnumIndexComparable', () {
    test('greater than', () {
      check(_TestEnum.foo > _TestEnum.bar).isFalse();
      check(_TestEnum.bar > _TestEnum.foo).isTrue();
    });

    test('greater or equal', () {
      check(_TestEnum.foo >= _TestEnum.bar).isFalse();
      check(_TestEnum.bar >= _TestEnum.bar).isTrue();
      check(_TestEnum.baz >= _TestEnum.bar).isTrue();
    });

    test('less than', () {
      check(_TestEnum.bar < _TestEnum.foo).isFalse();
      check(_TestEnum.foo < _TestEnum.bar).isTrue();
    });

    test('less or equal', () {
      check(_TestEnum.foo <= _TestEnum.bar).isTrue();
      check(_TestEnum.bar <= _TestEnum.bar).isTrue();
      check(_TestEnum.baz <= _TestEnum.bar).isFalse();
    });

    test('sortable', () {
      final unordered = [_TestEnum.baz, _TestEnum.foo, _TestEnum.bar];
      check(unordered..sort()).deepEquals(_TestEnum.values);
    });
  });
}
