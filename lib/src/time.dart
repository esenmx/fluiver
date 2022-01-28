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

  DateTime addYears(int years) => copyWith(year: year - years);

  DateTime addMonths(int months) => copyWith(month: month - months);

  DateTime addDays(int days) => add(Duration(days: days));

  DateTime addHours(int hours) => add(Duration(hours: hours));

  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));
}

extension TimeOfDayExtensions on TimeOfDay {
  DateTime get inToday => DateTime.now().copyWith(hour: hour, minute: minute);

  DateTime get inTomorrow => inToday.add(const Duration(days: 1));

  DateTime get inNextWeek => inToday.add(const Duration(days: 7));

  DateTime get inYesterday => inToday.subtract(const Duration(days: 1));

  DateTime get inLastWeek => inToday.subtract(const Duration(days: 7));
}
