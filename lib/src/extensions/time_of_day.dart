import 'package:flutter/material.dart' as legacy_material show TimeOfDay;
import 'package:material_ui/material_ui.dart' as material_ui show TimeOfDay;

DateTime _anchorTimeOnDate(int hour, int minute, DateTime date) {
  if (date.isUtc) {
    return .utc(date.year, date.month, date.day, hour, minute);
  }
  return DateTime(date.year, date.month, date.day, hour, minute);
}

/// Anchoring a [material_ui.TimeOfDay] onto a [DateTime] calendar day.
extension TimeOfDayOnDate on material_ui.TimeOfDay {
  /// Returns a [DateTime] on [date] at this time-of-day, with seconds and
  /// subseconds zeroed.
  ///
  /// ```dart
  /// const TimeOfDay(hour: 9, minute: 0).onDate(DateTime.now()); // today 09:00
  /// const TimeOfDay(hour: 9, minute: 0).onDate(meeting.day); // any date 09:00
  /// ```
  ///
  /// Takes the date explicitly rather than reading [DateTime.now()] inside,
  /// so callers control the clock and tests stay deterministic.
  ///
  /// The calendar day is read in [date]'s own zone flavor and the result
  /// stays in that flavor — fields and constructor never mix
  /// representations. Which *day* you mean near a day boundary is the
  /// caller's choice: `.toLocal()` / `.toUtc()` the date first.
  DateTime onDate(DateTime date) => _anchorTimeOnDate(hour, minute, date);
}

/// Anchoring a legacy `package:flutter/material.dart` [legacy_material.TimeOfDay]
/// onto a [DateTime] calendar day.
extension LegacyTimeOfDayOnDate on legacy_material.TimeOfDay {
  /// Returns a [DateTime] on [date] at this time-of-day, with seconds and
  /// subseconds zeroed.
  ///
  /// Same contract as [TimeOfDayOnDate.onDate] for callers still importing
  /// `TimeOfDay` from `package:flutter/material.dart`.
  DateTime onDate(DateTime date) => _anchorTimeOnDate(hour, minute, date);
}
