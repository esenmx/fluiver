part of '../../fluiver.dart';

/// {@macro extensionFor}
/// String capitalization and formatting.
extension StringCapitalize on String {
  String get capitalize {
    return switch (length) {
      0 => '',
      1 => toUpperCase(),
      _ => this[0].toUpperCase() + substring(1),
    };
  }

  String capitalizeAll({String separator = ' ', String? joiner}) {
    return split(separator)
        .where((e) => e.isNotEmpty)
        .map((e) => e.capitalize)
        .join(joiner ?? separator);
  }

  /// Useful when generating avatars based on name(similar to Google avatars)
  /// John Doe => JD
  /// John doe => Jd
  String initials({String separator = ' ', String joiner = ''}) {
    final names = split(separator).where((e) => e.isNotEmpty);
    return switch (names.length) {
      0 => '',
      1 => names.first[0],
      _ => names.map((e) => e[0]).join(joiner),
    };
  }
}

/// {@macro extensionFor}
/// {@macro safeOperation}
extension SafeString on String {
  String safeSubstring(int start, [int? end]) {
    if (start >= length) {
      return '';
    }
    if (end != null && end > length) {
      return substring(start, length);
    }
    return substring(start, end);
  }
}
