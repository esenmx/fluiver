part of fluiver;

extension ListX<T> on List<T> {
  Iterable<T> safeSubList(int start, [int? end]) {
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
}
