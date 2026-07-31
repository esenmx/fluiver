part of '../../fluiver.dart';

/// Filtering [Map] entries by key or value type.
///
/// These traverse the whole map, so they go through [forEach], which hands the
/// key and value straight to the callback — no `MapEntry` per entry, and no
/// lookup either. Measured ~20% faster than a collection-`for` over [entries]
/// in AOT. Predicates that can exit early (`any`/`every`/first-match) belong
/// on [Map.entries] instead — that's stdlib territory, not fluiver's.
extension MapFilter<K, V> on Map<K, V> {
  /// Returns a new map containing only the entries that satisfy [test].
  Map<K, V> where(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) result[key] = value;
    });
    return result;
  }

  /// Returns a new map containing only entries whose key is a [T].
  Map<T, V> whereKeyType<T>() {
    final result = <T, V>{};
    forEach((key, value) {
      if (key is T) result[key as T] = value;
    });
    return result;
  }

  /// Returns a new map containing only entries whose value is a [T].
  Map<K, T> whereValueType<T>() {
    final result = <K, T>{};
    forEach((key, value) {
      if (value is T) result[key] = value as T;
    });
    return result;
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
