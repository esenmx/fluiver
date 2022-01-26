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

  String get capitalizeAll => split(' ').map((e) => e.capitalize).join(' ');
}

extension StringCheckExtensions on String? {
  bool get isEmptyOrNull => this == null || (this?.isEmpty ?? true);
}

extension StringConverterExtensions on String? {
  DateTime? get tryNullParseDateTime =>
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
      final colorValue = int.tryParse(stringValue, radix: 16);
      if (colorValue == null) {
        return null;
      }
      return Color(colorValue);
    }
  }
}
