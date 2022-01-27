extension IterableNumExtensions on Iterable<num> {
  num get sum => fold(0, (previousValue, element) => previousValue + element);

  num get average {
    switch (length) {
      case 0:
        throw StateError('no element in $runtimeType');
      default:
        return sum / length;
    }
  }
}

extension IterableDoubleExtensions on Iterable<double> {
  Iterable<int> get toIntIterable => map((e) => e.toInt());
}

extension IterableIntExtensions on Iterable<int> {
  Iterable<double> get toDoubleIterable => map((e) => e.toDouble());
}
