part of fluiver;

extension IterableDoubleX on Iterable<double> {
  double sum() => fold(0.0, (previous, element) => previous + element);

  double average() => sum() / length;
}

extension IterableIntX on Iterable<int> {
  int sum() => fold(0, (previous, element) => previous + element);

  double average() => sum() / length;

  Uint8List toBytes() => Uint8List.fromList(toList());
}

extension IterableNumX<T extends num> on Iterable<T> {
  T get lowest => reduce((v, e) => e < v ? e : v);

  T lowestOrElse([T? orElse]) {
    if (isEmpty) {
      if (orElse == null) {
        throw StateError('no element found and `orElse` is null');
      }
      return orElse;
    }
    return lowest;
  }

  T get highest => reduce((v, e) => e > v ? e : v);

  T highestOrElse([T? orElse]) {
    if (isEmpty) {
      if (orElse == null) {
        throw StateError('no element found and `orElse` is null');
      }
      return orElse;
    }
    return highest;
  }
}
