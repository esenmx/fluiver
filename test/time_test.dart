import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final value = DateTime(1990, 6, 26, 8, 30);
  test('DateTimeX', () {
    expect(value.toDate(), DateTime(1990, 6, 26));
    expect(value.toTime(), const TimeOfDay(hour: 8, minute: 30));
    expect(value.addYears(31), value.copyWith(year: 2021));
    expect(value.addYears(-5000), value.copyWith(year: -3010));
    expect(value.addMonths(4), value.copyWith(month: 10));
    expect(value.addMonths(12), value.copyWith(year: 1991));
    expect(value.addMonths(13), value.copyWith(year: 1991, month: 7));
    expect(value.addMonths(-23), value.copyWith(year: 1988, month: 7));
    expect(value.addDays(3), value.copyWith(day: 29));
    expect(value.addHours(12), value.copyWith(hour: 20));
    expect(value.addMinutes(15), value.copyWith(minute: 45));
    expect(value.addMinutes(30), value.copyWith(hour: 9, minute: 0));
    expect(value.addSeconds(30), value.copyWith(second: 30));
    expect(value.addSeconds(60), value.copyWith(minute: 31, second: 0));
  });
}
