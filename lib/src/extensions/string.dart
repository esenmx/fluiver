part of fluiver;

extension StringCapitalize on String {
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

  /// Useful when generating avatars based on name(similar to Google avatars)
  /// John Doe => JD
  /// John doe => Jd
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
}

// extension StringRemove on String {
//   String? removePrefixOrNull(String prefix) {
//     if (startsWith(prefix)) {
//       return substring(prefix.length, length);
//     }
//     return null;
//   }

//   String? removeSuffixOrNull(String suffix) {
//     if (endsWith(suffix)) {
//       return substring(0, length - suffix.length);
//     }
//     return null;
//   }
// }

extension SafeString on String {
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

// extension StringSearch on String {
//   bool hasSearchMatch(String search, [String separator = ' ']) {
//     Iterable<String> prepare(String string, String separator) {
//       return string.toLowerCase().split(separator).where((e) => e.isNotEmpty);
//     }

//     final words = prepare(this, separator);
//     final parts = prepare(search, ' ');
//     // TODO remove found words within every
//     return parts.every((part) => words.any((word) => word.contains(part)));
//   }
// }
