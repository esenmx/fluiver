part of fluiver;

extension SetX<E> on Set<E> {
  Set<E> subset(int start, [int? end]) {
    RangeError.checkValidRange(start, end, length);
    final s = <E>{};
    for (var i = start; i < (end ?? length); i++) {
      s.add(elementAt(i));
    }
    return s;
  }

  E? elementAtOrNull(int index) {
    if (index < length) {
      return elementAt(index);
    }
    return null;
  }
}
