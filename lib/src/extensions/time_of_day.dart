part of fluiver;

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
