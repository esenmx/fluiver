part of fluiver;

extension StringCapitalizeX on String {
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

  String capitalizeEach([String separator = ' ']) {
    return split(separator)
        .map((element) => element.capitalize)
        .where((element) => element.isNotEmpty)
        .join(separator);
  }

  /// Also ensures lowercase status of noninitial letters
  ///
  /// capitalize: darT => DarT
  /// enhancedCapitalize: dART => Dart
  ///
  String get enhancedCapitalize {
    switch (length) {
      case 0:
        return this;
      case 1:
        return toUpperCase();
      default:
        final buffer = StringBuffer(this[0].toUpperCase());
        for (int i = 1; i < length; i++) {
          buffer.write(this[i].toLowerCase());
        }
        return buffer.toString();
    }
  }

  ///
  /// john doe => J. Doe
  /// j dOE => J Doe
  /// john J dOE => J. J Doe
  ///
  String nameAbbreviation() {
    if (trim().isEmpty) {
      return '';
    }
    final names = split(' ');
    final buffer = StringBuffer();
    for (int i = 0; i < names.length; i++) {
      if (i == names.length - 1) {
        buffer.write(names.elementAt(i).enhancedCapitalize);
      } else {
        final name = names.elementAt(i);
        if (name.length == 1) {
          buffer.write('${name.toUpperCase()} ');
        } else {
          buffer.write('${name[0].toUpperCase()}. ');
        }
      }
    }
    return buffer.toString();
  }
}

extension StringRemoveX on String {
  String? removePrefixOrNull(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return null;
  }

  String mayRemovePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return this;
  }

  String? removeSuffixOrNull(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return null;
  }

  String mayRemoveSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
}
