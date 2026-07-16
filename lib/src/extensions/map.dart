part of '../../fluiver.dart';

/// Predicate operations on [Map].
extension MapPredicate<K, V> on Map<K, V> {
  /// Whether at least one entry satisfies [test].
  bool any(bool Function(K key, V value) test) {
    for (final key in keys) {
      if (test(key, this[key] as V)) {
        return true;
      }
    }
    return false;
  }

  /// Whether every entry satisfies [test].
  bool every(bool Function(K key, V value) test) {
    for (final key in keys) {
      if (!test(key, this[key] as V)) {
        return false;
      }
    }
    return true;
  }

  /// Returns the first entry that satisfies [test], or `null` if none does.
  MapEntry<K, V>? firstWhereOrNull(bool Function(K key, V value) test) {
    for (final key in keys) {
      final value = this[key] as V;
      if (test(key, value)) {
        return MapEntry(key, value);
      }
    }
    return null;
  }
}

/// Filtering [Map] entries by key or value type.
extension MapFilter<K, V> on Map<K, V> {
  /// Returns a new map containing only the entries that satisfy [test].
  Map<K, V> where(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Returns a new map containing only entries whose key is a [T].
  Map<T, V> whereKeyType<T>() {
    final result = <T, V>{};
    forEach((key, value) {
      if (key is T) {
        result[key as T] = value;
      }
    });
    return result;
  }

  /// Returns a new map containing only entries whose value is a [T].
  Map<K, T> whereValueType<T>() {
    final result = <K, T>{};
    forEach((key, value) {
      if (value is T) {
        result[key] = value as T;
      }
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
