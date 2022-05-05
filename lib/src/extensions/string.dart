part of fluiver;

extension StringCapitalizeExtensions on String {
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

  ///
  /// john doe => J. Doe
  ///
  String nameAbbreviation() {
    if (trim().isEmpty) {
      return '';
    }
    final names = split(' ');
    final buffer = StringBuffer();
    for (int i = 0; i < names.length; i++) {
      if (i == names.length - 1) {
        buffer.write(names.elementAt(i).capitalize);
      } else {
        buffer.write('${names.elementAt(i)[0].toUpperCase()}. ');
      }
    }
    return buffer.toString();
  }
}

extension StringRemoveExtensions on String {
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
