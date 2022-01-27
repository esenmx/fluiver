import 'dart:ui';

extension StringModifyExtensions on String {
  String get capitalize {
    switch (length) {
      case 0:
        return this;
      case 1:
        return toUpperCase();
      default:
        return this[0].toUpperCase() + substring(1);
    }
  }

  String splitCapitalizeAll([String separator = ' ']) =>
      split(separator).map((e) => e.capitalize).join(separator);
}

extension NullStringCheckExtensions on String? {
  /// [Null] or an empty [String]
  bool get isEmptyOrNull => this == null || (this?.isEmpty ?? true);

  /// Can be [Null] and is a not empty [String]
  bool get isNotEmptyNullable => this?.isNotEmpty == true;

  /// Can be [Null] and is an empty [String]
  bool get isEmptyNullable => this?.isEmpty == true;
}

extension NullStringConverterExtensions on String? {
  DateTime? get tryParseDateTime =>
      this == null ? null : DateTime.tryParse(this!);
}

extension StringColorExtensions on String {
  Color? get tryParseHexColor {
    String? stringValue;
    if (startsWith('#') && length == 7) {
      /// #7916fa format
      stringValue = 'FF' + substring(1);
    }
    if ((startsWith('FF') || startsWith('ff')) && length == 8) {
      /// ff7916fa format
      stringValue = this;
    }
    if ((startsWith('0X') || startsWith('0x')) && length == 10) {
      /// 0xff7916fa format
      stringValue = substring(2);
    }
    if (stringValue != null) {
      final hexValue = int.tryParse(stringValue, radix: 16);
      if (hexValue == null) {
        return null;
      }
      return Color(hexValue);
    }
  }
}
