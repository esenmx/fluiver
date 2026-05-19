import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onDate', () {
    test('anchors time onto date and zeros seconds', () {
      final result = const TimeOfDay(
        hour: 9,
        minute: 30,
      ).onDate(DateTime(2024, 6, 15, 23, 59, 59, 999, 999));
      check(result).equals(DateTime(2024, 6, 15, 9, 30));
    });

    test('past date works', () {
      final result = const TimeOfDay(
        hour: 7,
        minute: 0,
      ).onDate(DateTime(1999, 12, 31));
      check(result).equals(DateTime(1999, 12, 31, 7));
    });

    test('future date works', () {
      final result = const TimeOfDay(
        hour: 23,
        minute: 45,
      ).onDate(DateTime(2099, 6, 15));
      check(result).equals(DateTime(2099, 6, 15, 23, 45));
    });

    test('midnight produces day boundary', () {
      final result = const TimeOfDay(
        hour: 0,
        minute: 0,
      ).onDate(DateTime(2024, 6, 15));
      check(result).equals(DateTime(2024, 6, 15));
    });
  });
}
