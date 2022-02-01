part of dashx;

extension StringModifyExtensions on String {
  ///
  /// Capitalize
  ///

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

  String splitCapitalizeAll([String separator = ' ']) => split(separator)
      .map((element) => element.capitalize)
      .where((element) => element.isNotEmpty)
      .join(separator);

  ///
  /// Remove
  ///

  String? tryRemovePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
  }

  String? tryRemoveSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(length - suffix.length, length);
    }
  }
}

extension NullStringCheckExtensions on String? {
  /// [Null] or an empty [String]
  bool get isEmptyOrNull => this == null || (this?.isEmpty ?? true);

  /// Can be [Null] and is a not empty [String]
  bool get isNotEmptyTrue => this?.isNotEmpty == true;

  /// Can be [Null] and is an empty [String]
  bool get isEmptyTrue => this?.isEmpty == true;
}

extension NullStringConverterExtensions on String? {
  DateTime? get tryParseDateTime =>
      this == null ? null : DateTime.tryParse(this!);
}

extension StringColorExtensions on String {
  Color? get tryParseHexColor {
    String? stringValue;

    /// #7916fa format
    if (startsWith('#') && length == 7) {
      stringValue = 'FF' + substring(1);
    }

    /// ff7916fa format
    else if ((startsWith('FF') || startsWith('ff')) && length == 8) {
      stringValue = this;
    }

    /// 0xff7916fa format
    else if ((startsWith('0X') || startsWith('0x')) && length == 10) {
      stringValue = substring(2);
    }

    /// hex value parse
    final hexValue = int.tryParse(stringValue ?? this, radix: 16);
    return hexValue != null ? Color(hexValue) : null;
  }
}
