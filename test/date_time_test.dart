import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final value = DateTime(1990, 6, 26, 8, 30);
  group('DateTimeX', () {
    test('toDate', () {
      expect(value.toDate(), DateTime(1990, 6, 26));
    });

    test('toTime', () {
      expect(value.toTime(), const TimeOfDay(hour: 8, minute: 30));
    });

    test('truncate', () {
      var value = DateTime(2020, 10, 25, 16, 35, 40);
      expect(value.truncate(const Duration(days: 1)),
          value.copyWith(hour: 0, minute: 0, second: 0));
      expect(value.truncate(const Duration(hours: 1)),
          value.copyWith(minute: 0, second: 0));
      expect(value.truncate(const Duration(minutes: 15)),
          value.copyWith(minute: 30, second: 0));
      expect(value.truncate(const Duration(minutes: 1)),
          value.copyWith(second: 0));
      value = DateTime(1901, 10, 25, 16, 35, 40);
      expect(value.truncate(const Duration(days: 1)),
          value.copyWith(hour: 0, minute: 0, second: 0));
      expect(value.truncate(const Duration(minutes: 15)),
          value.copyWith(minute: 30, second: 0));
      expect(value.truncate(const Duration(minutes: 1)),
          value.copyWith(second: 0));
      expect(value.truncate(const Duration(hours: 1)),
          value.copyWith(minute: 0, second: 0));
    });

    test('round', () {
      var v1 = const TimeOfDay(hour: 0, minute: 29).inToday();
      var v2 = const TimeOfDay(hour: 0, minute: 31).inToday();
      const modulus = Duration(hours: 1);
      expect(v1.round(modulus), v1.copyWith(minute: 0));
      expect(v2.round(modulus), v2.copyWith(hour: 1, minute: 0));
    });

    test('addYears', () {
      expect(value.addYears(31), value.copyWith(year: 2021));
      expect(value.addYears(-5000), value.copyWith(year: -3010));
    });

    test('addMonths', () {
      expect(value.addMonths(4), value.copyWith(month: 10));
      expect(value.addMonths(12), value.copyWith(year: 1991));
      expect(value.addMonths(13), value.copyWith(year: 1991, month: 7));
      expect(value.addMonths(-23), value.copyWith(year: 1988, month: 7));
    });

    test('addDays', () {
      expect(value.addDays(3), value.copyWith(day: 29));
    });

    test('addHours', () {
      expect(value.addHours(12), value.copyWith(hour: 20));
    });

    test('addMinutes', () {
      expect(value.addMinutes(15), value.copyWith(minute: 45));
      expect(value.addMinutes(30), value.copyWith(hour: 9, minute: 0));
    });

    test('addSeconds', () {
      expect(value.addSeconds(30), value.copyWith(second: 30));
      expect(value.addSeconds(60), value.copyWith(minute: 31, second: 0));
    });

    test('age', () {
      final year = DateTime.now().year;
      final day = DateTime.now().day;
      const margin = Duration(seconds: 1);
      expect(DateTime.now().copyWith(year: 1990, month: 1, day: 1).age, 32);
      expect(DateTime.now().copyWith(year: year - 10, day: day + 1).age, 9);
      expect(DateTime.now().subtract(margin).age, 0);
      expect(DateTime.now().copyWith(year: year - 1).subtract(margin).age, 1);
      expect(DateTime.now().copyWith(year: year - 1).add(margin).age, 0);
    });
  });
}
