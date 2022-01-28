part of dashx;

extension IterableDoubleExtensions on Iterable<double> {
  double get sum => fold(0.0, (previous, element) => previous + element);

  Iterable<int> get toIntIterable => map((e) => e.toInt());

  double get average => sum / length;
}

extension IterableIntExtensions on Iterable<int> {
  int get sum => fold(0, (previous, element) => previous + element);

  Iterable<double> get toDoubleIterable => map((e) => e.toDouble());

  double get average => sum / length;

  Uint8List get toBytes => Uint8List.fromList(toList());
}
