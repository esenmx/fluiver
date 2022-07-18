part of fluiver;

extension ListX<E> on List<E> {
  Iterable<E> safeSubList(int start, [int? end]) {
    if (start >= length) {
      return [];
    }
    if (end != null) {
      if (end > length) {
        return sublist(start, length);
      }
    }
    return sublist(start, end);
  }

  E? elementAtOrNull(int index) {
    if (index < length) {
      return elementAt(index);
    }
    return null;
  }
}
