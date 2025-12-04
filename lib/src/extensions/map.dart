part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Predicate operations on [Map].
extension MapPredicate<K, V> on Map<K, V> {
  bool any(bool Function(K key, V value) test) {
    return entries.any((entry) {
      return test(entry.key, entry.value);
    });
  }

  bool every(bool Function(K key, V value) test) {
    return entries.every((entry) {
      return test(entry.key, entry.value);
    });
  }

  MapEntry<K, V>? firstWhereOrNull(bool Function(K key, V value) test) {
    for (final e in entries) {
      if (test(e.key, e.value)) {
        return MapEntry(e.key, e.value);
      }
    }
    return null;
  }
}

/// {@macro extensionFor}
/// Filtering [Map] entries by key or value type.
extension MapFilter<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K key, V value) test) {
    return <K, V>{
      for (final e in entries)
        if (test(e.key, e.value)) e.key: e.value,
    };
  }

  Map<T, V> whereKeyType<T>() {
    return <T, V>{
      for (final entry in entries)
        if (entry.key is T) entry.key as T: entry.value,
    };
  }

  Map<K, T> whereValueType<T>() {
    return <K, T>{
      for (final entry in entries)
        if (entry.value is T) entry.key: entry.value as T,
    };
  }
}

/// {@macro extensionFor}
/// Getting [MapEntry] from [Map].
extension MapMapEntry<K, V> on Map<K, V> {
  MapEntry<K, V>? entryOf(K k) {
    final value = this[k];
    if (value == null) {
      return null;
    }
    return MapEntry<K, V>(k, value);
  }
}
