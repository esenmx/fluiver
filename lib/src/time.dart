part of dashx;

extension DateTimeExtensions on DateTime {
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

  TimeOfDay get toTimeOfDay => TimeOfDay(hour: hour, minute: minute);

  DateTime addYears(int years) {
    return copyWith(year: year + years);
  }

  DateTime addMonths(int months) {
    return copyWith(year: year + months ~/ 12, month: month + months % 12);
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  DateTime addHours(int hours) {
    return add(Duration(hours: hours));
  }

  DateTime addMinutes(int minutes) {
    return add(Duration(minutes: minutes));
  }

  DateTime addSeconds(int seconds) {
    return add(Duration(seconds: seconds));
  }
}

extension TimeOfDayExtensions on TimeOfDay {
  DateTime get inToday {
    return DateTime.now().copyWith(hour: hour, minute: minute);
  }

  DateTime get inTomorrow {
    return inToday.add(const Duration(days: 1));
  }

  DateTime get inNextWeek {
    return inToday.add(const Duration(days: 7));
  }

  DateTime get inYesterday {
    return inToday.subtract(const Duration(days: 1));
  }

  DateTime get inLastWeek {
    return inToday.subtract(const Duration(days: 7));
  }
}
