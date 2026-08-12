part of '../../fluiver.dart';

/// Mixin for comparing [Enum] values by their index.
///
/// ```dart
/// enum Enums with EnumIndexComparable<Enums> {
///   one,
///   two,
///   three;
/// }
/// ```
mixin EnumIndexComparable<T extends Enum> on Enum implements Comparable<T> {
  /// Whether this value's index is less than [other]'s.
  bool operator <(T other) => index < other.index;

  /// Whether this value's index is less than or equal to [other]'s.
  bool operator <=(T other) => index <= other.index;

  /// Whether this value's index is greater than [other]'s.
  bool operator >(T other) => index > other.index;

  /// Whether this value's index is greater than or equal to [other]'s.
  bool operator >=(T other) => index >= other.index;

  @override
  int compareTo(T other) => index - other.index;
}

final _enumNameCache = Expando<Map<String, Enum>>();

/// Working with [Enum] collections.
extension IterableEnum<T extends Enum> on Iterable<T> {
  /// Returns the enum value whose `name` matches [name], or `null` if none.
  ///
  /// Non-throwing counterpart to `Enum.byName`; chain `?? .fallback`.
  /// Unlike core's `values.asNameMap()[name]`, this avoids allocating
  /// a map per lookup. It selectively caches the map using an [Expando]
  /// for larger static lists (like `Enum.values`) to provide O(1) performance,
  /// while falling back to a plain scan for small or dynamic iterables
  /// to avoid unnecessary caching overhead.
  T? byNameOrNull(String name) {
    // Only attempt caching if `this` is a List and has a sufficient size.
    // Enum.values is a constant List, so it can be cached in an Expando.
    // The threshold of 16 ensures we don't penalize small, single-use subsets
    // with heavy map allocations.
    if (this is List<T> && (this as List<T>).length > 16) {
      var map = _enumNameCache[this];
      if (map == null) {
        map = this.asNameMap();
        _enumNameCache[this] = map;
      }
      return map[name] as T?;
    }

    // Fallback plain scan for small or non-List iterables.
    for (final e in this) {
      if (e.name == name) {
        return e;
      }
    }
    return null;
  }
}
