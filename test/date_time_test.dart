import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dt = DateTime(1990, 6, 26, 8, 30);

  group('truncateTime', () {
    test('removes time components', () {
      check(dt.truncateTime()).equals(DateTime(1990, 6, 26));
    });
  });

  group('toTimeOfDay', () {
    test('extracts time', () {
      check(dt.toTimeOfDay()).equals(const TimeOfDay(hour: 8, minute: 30));
    });
  });

  group('addYears', () {
    test('positive', () => check(dt.addYears(31).year).equals(2021));
    test('negative', () => check(dt.addYears(-5000).year).equals(-3010));
  });

  group('addMonths', () {
    test('same year', () => check(dt.addMonths(4).month).equals(10));
    test('next year', () {
      final result = dt.addMonths(12);
      check(result.year).equals(1991);
      check(result.month).equals(6);
    });
    test('negative', () {
      final result = dt.addMonths(-23);
      check(result.year).equals(1988);
      check(result.month).equals(7);
    });
  });

  group('addDays', () {
    test('positive', () => check(dt.addDays(3).day).equals(29));
  });

  group('addHours', () {
    test('positive', () => check(dt.addHours(12).hour).equals(20));
  });

  group('addMinutes', () {
    test('same hour', () => check(dt.addMinutes(15).minute).equals(45));
    test('next hour', () {
      final result = dt.addMinutes(30);
      check(result.hour).equals(9);
      check(result.minute).equals(0);
    });
  });

  group('age', () {
    final now = DateTime.now();
    final year = now.year;

    test('past birthday this year', () {
      final birth = now.copyWith(year: 1990, month: 1, day: 1);
      check(birth.age()).equals(year - 1990);
    });

    test('future birthday this year', () {
      final birth = now.copyWith(year: year - 10, day: now.day + 1);
      check(birth.age()).equals(9);
    });

    test('born today', () {
      check(now.age()).equals(0);
    });

    test('one year ago minus margin', () {
      final birth =
          now.copyWith(year: year - 1).subtract(const Duration(seconds: 1));
      check(birth.age()).equals(1);
    });
  });
}
