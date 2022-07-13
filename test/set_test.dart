import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SetX', () {
    test('subset', () {
      expect(() => <int>{}.subset(1), throwsA(isA<RangeError>()));
      expect(() => <int>{}.subset(0, 1), throwsA(isA<RangeError>()));
      expect(() => {1, 2, 3}.subset(3, 2), throwsA(isA<RangeError>()));
      expect({1, 2, 3}.subset(0), {1, 2, 3});
      expect({1, 2, 3}.subset(1), {2, 3});
      expect({1, 2, 3}.subset(0, 2), {1, 2});
      expect({1, 2, 3}.subset(1, 2), {2});
      expect({1, 2, 3}.subset(2, 2), <int>{});
    });
  });
}
