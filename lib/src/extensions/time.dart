part of fluiver;

extension DateTimeX on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime toDate() => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);

  DateTime truncate(Duration margin) {
    final truncated = subtract(Duration(
      microseconds: microsecondsSinceEpoch % margin.inMicroseconds,
    ));
    if (difference(truncated).abs() > timeZoneOffset) {
      return truncated.subtract(timeZoneOffset);
    }
    return truncated;
  }

  DateTime addYears(int years) => copyWith(year: year + years);

  DateTime addMonths(int months) => copyWith(month: month + months);

  DateTime addWeeks(int weeks) => copyWith(day: day + weeks * 7);

  DateTime addDays(int days) => copyWith(day: day + days);

  DateTime addHours(int hours) => copyWith(hour: hour + hours);

  DateTime addMinutes(int minutes) => copyWith(minute: minute + minutes);

  DateTime addSeconds(int seconds) => copyWith(second: second + seconds);

  bool get isToday {
    final n = DateTime.now();
    return n.day == day && n.month == month && n.year == year;
  }

  bool get isTomorrow {
    final t = DateTime.now().addDays(1);
    return t.day == day && t.month == month && t.year == year;
  }

  bool get isYesterday {
    final y = DateTime.now().addDays(-1);
    return y.day == day && y.month == month && y.year == year;
  }
}

extension TimeOfDayX on TimeOfDay {
  DateTime inToday() => DateTime.now().copyWith(hour: hour, minute: minute);
}
