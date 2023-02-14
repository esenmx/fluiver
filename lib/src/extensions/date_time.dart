part of fluiver;

extension DateTimeMerge on DateTime {
  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);

  DateTime truncateTime() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  DateTime withTimeOfDay(TimeOfDay time) {
    return truncateTime().copyWith(hour: time.hour, minute: time.minute);
  }
}

extension DateTimeAdd on DateTime {
  DateTime addYears(int years) => copyWith(year: year + years);
  DateTime addMonths(int months) => copyWith(month: month + months);
  DateTime addWeeks(int weeks) => copyWith(day: day + weeks * 7);
  DateTime addDays(int days) => copyWith(day: day + days);
  DateTime addHours(int hours) => copyWith(hour: hour + hours);
  DateTime addMinutes(int minutes) => copyWith(minute: minute + minutes);
  DateTime addSeconds(int seconds) => copyWith(second: second + seconds);
}

extension DateTimeCheck on DateTime {
  bool _offsetChecker(int dayOffset) {
    final l = toLocal();
    final n = DateTime.now().addDays(dayOffset);
    return n.day == l.day && n.month == l.month && n.year == l.year;
  }

  bool get isToday => _offsetChecker(0);
  bool get isTomorrow => _offsetChecker(1);
  bool get isYesterday => _offsetChecker(-1);

  bool isWithinFromNow(Duration duration) {
    return difference(DateTime.now()).inMicroseconds <= duration.inMicroseconds;
  }
}

extension DateTimeCalculator on DateTime {
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

  // TODO (diff - 2, 3, ... , n) cases
  int get age {
    var diff = DateTime.now().year - year;
    if (DateTime.now().copyWith(year: year).isAfter(this)) {
      return diff;
    }
    return diff - 1;
  }
}
