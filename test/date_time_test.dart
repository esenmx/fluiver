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

  group('withTimeOfDay', () {
    test('replaces time components', () {
      final merged = dt.withTimeOfDay(const TimeOfDay(hour: 14, minute: 5));
      check(merged).equals(DateTime(1990, 6, 26, 14, 5));
    });
  });

  group('toTimeOfDay', () {
    test('extracts time', () {
      check(dt.toTimeOfDay()).equals(const TimeOfDay(hour: 8, minute: 30));
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
      final birth = now
          .copyWith(year: year - 1)
          .subtract(const Duration(seconds: 1));
      check(birth.age()).equals(1);
    });
  });

  group('isToday / isTomorrow / isYesterday', () {
    test('isToday is true for now', () {
      check(DateTime.now().isToday).isTrue();
    });

    test('isToday is false for tomorrow', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1, 12);
      check(tomorrow.isToday).isFalse();
    });

    test('isTomorrow uses calendar shift not 24h', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1, 12);
      check(tomorrow.isTomorrow).isTrue();
    });

    test('isYesterday uses calendar shift not 24h', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1, 12);
      check(yesterday.isYesterday).isTrue();
    });

    test('predicates are mutually exclusive', () {
      final now = DateTime.now();
      check(now.isTomorrow).isFalse();
      check(now.isYesterday).isFalse();
    });
  });

  group('inThisYear', () {
    test('current year is true', () {
      check(DateTime.now().inThisYear).isTrue();
    });

    test('last year is false', () {
      final lastYear = DateTime(DateTime.now().year - 1, 6);
      check(lastYear.inThisYear).isFalse();
    });
  });

  group('isWithinFromNow', () {
    test('now is within any duration', () {
      check(
        DateTime.now().isWithinFromNow(const Duration(seconds: 1)),
      ).isTrue();
    });

    test('one hour ahead is outside one minute', () {
      final future = DateTime.now().add(const Duration(hours: 1));
      check(future.isWithinFromNow(const Duration(minutes: 1))).isFalse();
    });

    test('symmetric — past and future', () {
      final past = DateTime.now().subtract(const Duration(seconds: 30));
      check(past.isWithinFromNow(const Duration(minutes: 1))).isTrue();
    });
  });
}
