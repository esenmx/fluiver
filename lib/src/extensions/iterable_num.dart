part of fluiver;

extension IterableDoubleX on Iterable<double> {
  double sum() => fold(0.0, (previous, element) => previous + element);

  Iterable<int> toIntIterable() => map((e) => e.toInt());

  double average() => sum() / length;

  double get lowest => reduce((v, e) => e < v ? e : v);
}

extension IterableInt on Iterable<int> {
  int sum() => fold(0, (previous, element) => previous + element);

  Iterable<double> toDoubleIterable() => map((e) => e.toDouble());

  double average() => sum() / length;

  Uint8List toBytes() => Uint8List.fromList(toList());

  int get lowest => reduce((v, e) => e < v ? e : v);
}
