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

  String capitalizeEach([String separator = ' ']) {
    return split(separator)
        .map((element) => element.capitalize)
        .where((element) => element.isNotEmpty)
        .join(separator);
  }

  ///
  /// Remove
  ///

  String? tryRemovePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return null;
  }

  String safeRemovePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    }
    return this;
  }

  String? tryRemoveSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(length - suffix.length, length);
    }
    return null;
  }

  String safeRemoveSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(length - suffix.length, length);
    }
    return this;
  }
}
