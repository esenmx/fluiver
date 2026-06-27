part of '../../fluiver.dart';

/// Predicate operations on [Map].
extension MapPredicate<K, V> on Map<K, V> {
  /// Whether at least one entry satisfies [test].
  bool any(bool Function(K key, V value) test) {
    return entries.any((entry) {
      return test(entry.key, entry.value);
    });
  }

  /// Whether every entry satisfies [test].
  bool every(bool Function(K key, V value) test) {
    return entries.every((entry) {
      return test(entry.key, entry.value);
    });
  }

  /// Returns the first entry that satisfies [test], or `null` if none does.
  MapEntry<K, V>? firstWhereOrNull(bool Function(K key, V value) test) {
    for (final e in entries) {
      if (test(e.key, e.value)) {
        return MapEntry(e.key, e.value);
      }
    }
    return null;
  }
}

/// Filtering [Map] entries by key or value type.
extension MapFilter<K, V> on Map<K, V> {
  /// Returns a new map containing only the entries that satisfy [test].
  Map<K, V> where(bool Function(K key, V value) test) {
    return <K, V>{
      for (final e in entries)
        if (test(e.key, e.value)) e.key: e.value,
    };
  }

  /// Returns a new map containing only entries whose key is a [T].
  Map<T, V> whereKeyType<T>() {
    return <T, V>{
      for (final entry in entries)
        if (entry.key is T) entry.key as T: entry.value,
    };
  }

  /// Returns a new map containing only entries whose value is a [T].
  Map<K, T> whereValueType<T>() {
    return <K, T>{
      for (final entry in entries)
        if (entry.value is T) entry.key: entry.value as T,
    };
  }
}

/// Getting [MapEntry] from [Map].
extension MapMapEntry<K, V> on Map<K, V> {
  /// Returns the [MapEntry] for [k], or `null` if the key is absent.
  ///
  /// Distinguishes "key present with `null` value" from "key absent" —
  /// `{'a': null}.entryOf('a')` is `MapEntry('a', null)`, not `null`.
  MapEntry<K, V>? entryOf(K k) {
    final value = this[k];
    if (value != null || containsKey(k)) {
      return MapEntry<K, V>(k, value as V);
    }
    return null;
  }
}
