import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('SetX', () {
    test('toMap', () {
      expect(<int>{}.toMap<bool>((v) => true), <int, bool>{});
      final map = List<int>.generate(1000, (i) => i)
          .toSet()
          .toMap<int>((value) => value * value);
      for (final entry in map.entries) {
        expect(entry.key * entry.key, entry.value);
      }
    });
  });
}
