part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Numeric operations on [Iterable<double>].
extension IterableDouble on Iterable<double> {
  double sum() => fold(0, (previous, element) => previous + element);

  double average() => sum() / length;
}

/// {@macro extensionFor}
/// Numeric operations on [Iterable<int>].
extension IterableInt on Iterable<int> {
  int sum() => fold(0, (previous, element) => previous + element);

  double average() => sum() / length;

  Uint8List toBytes() => Uint8List.fromList(toList());
}

/// {@macro extensionFor}
/// Finding min/max values in numeric [Iterable].
extension IterableNum<T extends num> on Iterable<T> {
  T lowest() => reduce((v, e) => e < v ? e : v);

  T highest() => reduce((v, e) => e > v ? e : v);
}
