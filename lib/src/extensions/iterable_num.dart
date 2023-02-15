part of fluiver;

extension IterableDouble on Iterable<double> {
  double sum() => fold(0.0, (previous, element) => previous + element);

  double average() => sum() / length;
}

extension IterableInt on Iterable<int> {
  int sum() => fold(0, (previous, element) => previous + element);

  double average() => sum() / length;

  Uint8List toBytes() => Uint8List.fromList(toList());
}

extension IterableNum<T extends num> on Iterable<T> {
  T get lowest => reduce((v, e) => e < v ? e : v);

  T get highest => reduce((v, e) => e > v ? e : v);
}
