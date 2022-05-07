part of fluiver;

extension SetX<E> on Set<E> {
  Map<E, V> toMap<V>(V Function(E key) valueFromKey) {
    return <E, V>{for (final k in this) k: valueFromKey(k)};
  }
}
