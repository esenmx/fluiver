import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('subset', () {
    test('invalid start throws', () {
      check(() => <int>{}.subset(1)).throws<RangeError>();
    });
    test('invalid end throws', () {
      check(() => <int>{}.subset(0, 1)).throws<RangeError>();
    });
    test('invalid range throws', () {
      check(() => {1, 2, 3}.subset(3, 2)).throws<RangeError>();
    });
    test('full set', () {
      check({1, 2, 3}.subset(0)).deepEquals({1, 2, 3});
    });
    test('from index', () {
      check({1, 2, 3}.subset(1)).deepEquals({2, 3});
    });
    test('range', () {
      check({1, 2, 3}.subset(0, 2)).deepEquals({1, 2});
    });
    test('single element', () {
      check({1, 2, 3}.subset(1, 2)).deepEquals({2});
    });
    test('empty range', () {
      check({1, 2, 3}.subset(2, 2)).deepEquals(<int>{});
    });
  });
}
