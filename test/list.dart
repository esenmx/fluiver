import 'package:dashx/src/list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('ListExtensions<E>', () {
    test('swap', () {
      expect(() => []..swap(0, 1), throwsA(isA<RangeError>()));
      expect([1, 2]..swap(0, 1), [2, 1]);
      expect(() => [1, 2, 3]..swap(0, 4), throwsA(isA<RangeError>()));
      expect([1, 2, 3]..swap(0, 2), [3, 2, 1]);
    });
  });
}
