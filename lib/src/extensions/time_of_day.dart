part of '../../fluiver.dart';

/// Anchoring a [TimeOfDay] onto a [DateTime] calendar day.
extension TimeOfDayOnDate on TimeOfDay {
  /// Returns a [DateTime] on [date] at this time-of-day, with seconds and
  /// subseconds zeroed.
  ///
  /// ```dart
  /// const TimeOfDay(hour: 9).onDate(DateTime.now());   // today 09:00
  /// const TimeOfDay(hour: 9).onDate(meeting.day);      // meeting day 09:00
  /// ```
  ///
  /// Takes the date explicitly rather than reading [DateTime.now()] inside,
  /// so callers control the clock and tests stay deterministic.
  DateTime onDate(DateTime date) {
    if (date.isUtc) {
      return DateTime.utc(date.year, date.month, date.day, hour, minute);
    }
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
