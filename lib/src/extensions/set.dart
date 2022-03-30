part of fluiver;

extension SetExtensions<E> on Set<E> {
  Map<E, V> toMap<V>(V Function(E key) valueFromKey) {
    return <E, V>{for (final k in this) k: valueFromKey(k)};
  }
}
