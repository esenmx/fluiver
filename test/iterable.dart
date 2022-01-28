import 'package:dashx/dashx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final twoDimA = [
    [1, 2]
  ];
  final expandedA = [1, 2];
  final twoDimB = [
    [1, 2, 3],
    [4]
  ];
  final expandedB = [1, 2, 3, 4];
  final twoDimC = [
    [1, 2],
    [3, 4],
    [5, 6]
  ];
  final expandedC = [1, 2, 3, 4, 5, 6];

  group('IterableExtensions<E>', () {
    test('convertTo2D', () {
      expect([].convertTo2D(3), []);
      expect(<int>{}.convertTo2D(1), []);
      expect(expandedA.convertTo2D(2), twoDimA);
      expect(expandedB.convertTo2D(3), twoDimB);
      expect(expandedC.convertTo2D(2), twoDimC);
    });
  });

  group('Iterable2DExtensions<E>', () {
    test('expand2D', () {
      expect([[]].expand2D, []);
      expect([twoDimA].expand2D, expandedA);
      expect([twoDimA].expand2D, expandedA);
      expect(twoDimC.expand2D, expandedC);
    });
  });
}
