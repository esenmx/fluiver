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

  String capitalizeEach([String splitter = ' ', String? joiner]) {
    return split(splitter)
        .map((element) => element.capitalize)
        .where((element) => element.isNotEmpty)
        .join(joiner ?? splitter);
  }

  /// Also ensures lowercasing of noninitial letters
  ///
  /// capitalize: daRT => DaRT
  /// enhancedCapitalize: daRT => Dart
  String get capitalizeLowerLatter {
    switch (length) {
      case 0:
        return this;
      case 1:
        return toUpperCase();
      default:
        final iterator = characters.iterator..moveNext();
        final buffer = StringBuffer(iterator.current.toUpperCase());
        while (iterator.moveNext()) {
          buffer.write(iterator.current.toLowerCase());
        }
        return buffer.toString();
    }
  }

  /// john doe => J. Doe
  /// j dOE => J Doe
  /// john J dOE => J. J Doe
  String shortPersonalName() {
    final names = split(' ').where((e) => e.isNotEmpty);
    switch (names.length) {
      case 0:
        return this;
      case 1:
        return names.first.capitalizeLowerLatter;
      default:
        final buffer = StringBuffer();
        for (int i = 0; i < names.length - 1; i++) {
          final name = names.elementAt(i);
          switch (name.length) {
            case 0:
              break;
            case 1:
              buffer.write(name.toUpperCase());
              break;
            default:
              buffer.write(name[0].toUpperCase());
              buffer.write('.');
          }
          buffer.write(' ');
        }
        buffer.write(names.last.capitalizeLowerLatter);
        return buffer.toString();
    }
  }

  /// Useful when generating avatars based on name(similarly Google account avatars)
  /// John Doe => JD
  String avatarLetters() {
    final names = split(' ').where((e) => e.isNotEmpty);
    switch (names.length) {
      case 0:
        return this;
      case 1:
        return names.first[0].toUpperCase();
      default:
        return names.first[0].toUpperCase() + names.last[0].toUpperCase();
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
