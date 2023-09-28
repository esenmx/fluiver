import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final value = DateTime(1990, 6, 26, 8, 30);
  group('DateTime', () {
    test('toDate', () {
      expect(value.truncateTime(), DateTime(1990, 6, 26));
    });

    test('toTime', () {
      expect(value.toTimeOfDay(), const TimeOfDay(hour: 8, minute: 30));
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
      expect(
        DateTime.now().copyWith(year: 1990, month: 1, day: 1).humanAge,
        year - 1990,
      );
      expect(
        DateTime.now().copyWith(year: year - 10, day: day + 1).humanAge,
        9,
      );
      expect(DateTime.now().subtract(margin).humanAge, 0);
      expect(
        DateTime.now().copyWith(year: year - 1).subtract(margin).humanAge,
        1,
      );
      expect(DateTime.now().copyWith(year: year - 1).add(margin).humanAge, 0);
    });
  });
}
