part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Converting [TimeOfDay] to [DateTime].
extension TimeOfDayDateTime on TimeOfDay {
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
