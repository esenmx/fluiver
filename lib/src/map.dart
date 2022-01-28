part of dashx;

extension MapIterableInterfaceExtensions<K, V> on Map<K, V> {
  bool any(bool Function(K key, V value) test) =>
      entries.any((entry) => test(entry.key, entry.value));
}
