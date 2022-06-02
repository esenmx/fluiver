part of fluiver;

extension IterableDoubleX on Iterable<double> {
  double sum() => fold(0.0, (previous, element) => previous + element);

  double average() => sum() / length;

  double get lowestOrZero {
    if (isEmpty) {
      return 0;
    }
    return reduce((v, e) => e < v ? e : v);
  }
}

extension IterableIntX on Iterable<int> {
  int sum() => fold(0, (previous, element) => previous + element);

  double average() => sum() / length;

  Uint8List toBytes() => Uint8List.fromList(toList());

  int get lowestOrZero => isEmpty ? 0 : lowest;
}

extension IterableNumX<T extends num> on Iterable<T> {
  T get lowest => reduce((v, e) => e < v ? e : v);
}
