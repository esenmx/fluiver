part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Converting [DateTime] to [TimeOfDay].
extension DateTimeTimeOfDay on DateTime {
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}

/// {@macro extensionFor}
/// Merging time components with [DateTime].
extension DateTimeMerge on DateTime {
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

/// {@macro extensionFor}
/// Adding time units to [DateTime].
extension DateTimeAdd on DateTime {
  /// {@macro returns_datetime}
  DateTime addYears(int years) => copyWith(year: year + years);

  /// {@macro returns_datetime}
  DateTime addMonths(int months) => copyWith(month: month + months);

  /// {@macro returns_datetime}
  DateTime addWeeks(int weeks) => copyWith(day: day + weeks * 7);

  /// {@macro returns_datetime}
  DateTime addDays(int days) => copyWith(day: day + days);

  /// {@macro returns_datetime}
  DateTime addHours(int hours) => copyWith(hour: hour + hours);

  /// {@macro returns_datetime}
  DateTime addMinutes(int minutes) => copyWith(minute: minute + minutes);

  /// {@macro returns_datetime}
  DateTime addSeconds(int seconds) => copyWith(second: second + seconds);
}

/// {@macro extensionFor}
/// Checking date conditions on [DateTime].
extension DateTimeCheck on DateTime {
  bool _offsetChecker(int dayOffset) {
    final l = toLocal();
    final n = DateTime.now().addDays(dayOffset);
    return n.day == l.day && n.month == l.month && n.year == l.year;
  }

  bool get isToday => _offsetChecker(0);
  bool get isTomorrow => _offsetChecker(1);
  bool get isYesterday => _offsetChecker(-1);
  bool get inThisYear => toLocal().year == DateTime.now().year;

  bool isWithinFromNow(Duration duration) {
    return difference(DateTime.now()).inMicroseconds.abs() <=
        duration.inMicroseconds;
  }
}

/// {@macro extensionFor}
/// Calculating age from [DateTime].
extension DateTimeCalculator on DateTime {
  int age() {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
