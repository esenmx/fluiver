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
  ///
  /// The calendar day is read in [date]'s own zone flavor and the result
  /// stays in that flavor — fields and constructor never mix
  /// representations. Which *day* you mean near a day boundary is the
  /// caller's choice: `.toLocal()` / `.toUtc()` the date first.
  DateTime onDate(DateTime date) {
    if (date.isUtc) {
      return .utc(date.year, date.month, date.day, hour, minute);
    }
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
