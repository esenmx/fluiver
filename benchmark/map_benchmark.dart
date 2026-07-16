import 'package:fluiver/fluiver.dart';

void main() {
  final map = <int, int>{};
  for (int i = 0; i < 10000; i++) {
    map[i] = i;
  }

  final sw = Stopwatch()..start();
  for (int i = 0; i < 10000; i++) {
    map.firstWhereOrNull((k, v) => k == 9999);
  }
  sw.stop();
  print('Baseline firstWhereOrNull: ${sw.elapsedMilliseconds} ms');
}
