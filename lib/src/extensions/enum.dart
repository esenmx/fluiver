part of '../../fluiver.dart';

/// Mixin for comparing [Enum] values by their index.
///
/// ```dart
/// enum Enums with EnumIndexComparable {
///   one,
///   two,
///   three;
/// }
/// ```
mixin EnumIndexComparable on Enum implements Comparable<Enum> {
  /// Whether this value's index is less than [other]'s.
  bool operator <(Enum other) => index < other.index;

  /// Whether this value's index is less than or equal to [other]'s.
  bool operator <=(Enum other) => index <= other.index;

  /// Whether this value's index is greater than [other]'s.
  bool operator >(Enum other) => index > other.index;

  /// Whether this value's index is greater than or equal to [other]'s.
  bool operator >=(Enum other) => index >= other.index;

  @override
  int compareTo(Enum other) => index - other.index;
}

/// {@macro extensionFor}
/// Working with [Enum] collections.
extension IterableEnum<T extends Enum> on Iterable<T> {
  /// Returns the enum value whose `name` matches [name], or `null` if none.
  ///
  /// Non-throwing counterpart to `Enum.byName`. For a fallback use
  /// `Enum.values.byNameOrNull(s) ?? .fallback` — Dart shorthand handles it.
  T? byNameOrNull(String name) {
    for (final e in this) {
      if (e.name == name) {
        return e;
      }
    }
    return null;
  }
}
