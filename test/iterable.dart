import 'package:dashx/dashx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final twoDimA = [
    [1],
    [2]
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
      expect(expandedA.convertTo2D(1), twoDimA);
      expect(expandedB.convertTo2D(3), twoDimB);
      expect(expandedC.convertTo2D(2), twoDimC);
    });
  });

  group('Iterable2DExtensions<E>', () {
    test('expandFrom2D', () {
      expect([[]].expandFrom2D, []);
      expect(twoDimA.expandFrom2D.toList(), expandedA);
      expect(twoDimB.expandFrom2D.toList(), expandedB);
      expect(twoDimC.expandFrom2D.toList(), expandedC);
    });
  });
}
