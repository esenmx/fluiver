part of dashx;

extension SetExtensions<K> on Set<K> {
  Map<K, V> toMap<V>(V Function(K key) valueFromKey) {
    return <K, V>{for (final k in this) k: valueFromKey(k)};
  }
}
