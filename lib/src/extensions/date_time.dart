part of fluiver;

extension DateTimeX on DateTime {
  DateTime toDate() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);

  DateTime withTimeOfDay(TimeOfDay time) {
    return copyWith(hour: time.hour, minute: time.minute);
  }

  DateTime truncate(Duration modulus) {
    final truncated = subtract(Duration(
      microseconds: microsecondsSinceEpoch % modulus.inMicroseconds,
    ));
    if (difference(truncated).abs() > timeZoneOffset) {
      return truncated.subtract(timeZoneOffset);
    }
    return truncated;
  }

  DateTime round(Duration modulus) {
    final floor = truncate(modulus);
    final ceil = floor.add(modulus);
    if (difference(floor) > difference(ceil).abs()) {
      return ceil;
    }
    return floor;
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

  bool isWithinFromNow(Duration duration) {
    return difference(DateTime.now()).inMicroseconds <= duration.inMicroseconds;
  }

  // todo (diff - 2, 3, ... , n) cases
  int get age {
    final diff = DateTime.now().year - year;
    if (DateTime.now().copyWith(year: year).isAfter(this)) {
      return diff;
    }
    return diff - 1;
  }
}

extension TimeOfDayX on TimeOfDay {
  DateTime inToday() {
    return DateTime.now().copyWith(
      hour: hour,
      minute: minute,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }
}
