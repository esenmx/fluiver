part of '../../fluiver.dart';

/// Converting [DateTime] to [TimeOfDay].
extension DateTimeTimeOfDay on DateTime {
  /// Returns this date's hour and minute as a [TimeOfDay].
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}

/// Merging time components with [DateTime].
extension DateTimeMerge on DateTime {
  /// Returns this date with hour/minute/second/millisecond/microsecond
  /// zeroed.
  DateTime truncateTime() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  /// Returns this date with its time replaced by [time]; sub-minute
  /// components are zeroed.
  DateTime withTimeOfDay(TimeOfDay time) {
    return truncateTime().copyWith(hour: time.hour, minute: time.minute);
  }
}

/// Checking date conditions on [DateTime].
extension DateTimeCheck on DateTime {
  bool _offsetChecker(int dayOffset) {
    final l = toLocal();
    final now = DateTime.now();
    // Calendar-day shift, not 24h shift — `Duration(days: 1)` is 24h and
    // can land on the same calendar day across DST fall-back.
    final n = DateTime(now.year, now.month, now.day + dayOffset);
    return n.day == l.day && n.month == l.month && n.year == l.year;
  }

  /// Whether this date is the current local calendar day.
  bool get isToday => _offsetChecker(0);

  /// Whether this date is the next local calendar day.
  bool get isTomorrow => _offsetChecker(1);

  /// Whether this date is the previous local calendar day.
  bool get isYesterday => _offsetChecker(-1);

  /// Whether this date is in the current local calendar year.
  bool get inThisYear => toLocal().year == DateTime.now().year;

  /// Whether this date is within [duration] of `DateTime.now()`, in either
  /// direction.
  bool isWithinFromNow(Duration duration) {
    return difference(DateTime.now()).inMicroseconds.abs() <=
        duration.inMicroseconds;
  }
}

/// Calculating age from [DateTime].
extension DateTimeCalculator on DateTime {
  /// Returns the number of full years between this date and `DateTime.now()`.
  ///
  /// Accounts for the month/day boundary — a birthday that hasn't occurred
  /// yet this year subtracts one.
  int age() {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
