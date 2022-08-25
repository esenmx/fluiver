part of fluiver;

extension StringCapitalizeX on String {
  String get capitalize {
    switch (length) {
      case 0:
        return '';
      case 1:
        return toUpperCase();
      default:
        return this[0].toUpperCase() + substring(1);
    }
  }

  String capitalizeAll({String separator = ' ', String? joiner}) {
    return split(separator)
        .where((e) => e.isNotEmpty)
        .map((e) => e.capitalize)
        .join(joiner ?? separator);
  }

  /// Useful when generating avatars based on name(similarly Google account avatars)
  /// John Doe => JD
  String initials({String separator = ' ', String joiner = ''}) {
    final names = split(separator).where((e) => e.isNotEmpty);
    switch (names.length) {
      case 0:
        return '';
      case 1:
        return names.first[0];
      default:
        return names.map((e) => e[0]).join(joiner);
    }
  }

  /// john doe => J Doe
  /// j dOE => J Doe
  /// john J dOE => J. J Doe
  String initialsWithLast({
    String separator = ' ',
    String joiner = ' ',
    String suffix = '.',
  }) {
    final names = split(separator).where((e) => e.isNotEmpty);
    switch (names.length) {
      case 0:
        return '';
      case 1:
        return names.first.toLowerCase().capitalize;
      default:
        final initials = names
            .take(names.length - 1)
            .map((e) => '${e[0].toUpperCase()}$suffix')
            .join(joiner);
        return '$initials$separator${names.last.toLowerCase().capitalize}';
    }
  }
}

typedef StringOrElse = String Function(String string);

extension StringRemoveX on String {
  String? removePrefixOrNull(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return null;
  }

  String removePrefixOrElse(String prefix, [StringOrElse? orElse]) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return orElse?.call(this) ?? this;
  }

  String? removeSuffixOrNull(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return null;
  }

  String removeSuffixOrElse(String suffix, [StringOrElse? orElse]) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return orElse?.call(this) ?? this;
  }
}

extension StringSafeX on String {
  String safeSubstring(int start, [int? end]) {
    if (start >= length) {
      return '';
    }
    if (end != null) {
      if (end > length) {
        return substring(start, length);
      }
    }
    return substring(start, end);
  }
}

extension StringSearchX on String {
  bool textSearch(String search, [String separator = ' ']) {
    Iterable<String> prepare(String string, String separator) {
      return string.toLowerCase().split(separator).where((e) => e.isNotEmpty);
    }

    final words = prepare(this, separator);
    final parts = prepare(search, ' ');
    // TODO remove found words within every
    return parts.every((part) => words.any((word) => word.contains(part)));
  }
}
