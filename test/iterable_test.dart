import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rand/rand.dart';

void main() async {
  final twoDimA = [
    [1],
    [2],
  ];
  final expandedA = [1, 2];
  final twoDimB = [
    [1, 2, 3],
    [4],
  ];
  final expandedB = [1, 2, 3, 4];
  final twoDimC = [
    [1, 2],
    [3, 4],
    [5, 6],
  ];
  final expandedC = [1, 2, 3, 4, 5, 6];

  group('IterableX', () {
    test('sub', () {
      expect(() => [].subIteration(1), throwsA(isA<RangeError>()));
      expect(() => [].subIteration(0, 2), throwsA(isA<RangeError>()));
      expect([].subIteration(0, 0).toList(), []);
      expect([1, 2, 3].subIteration(0).toList(), [1, 2, 3]);
      expect([1, 2, 3].subIteration(1).toList(), [2, 3]);
      expect([1, 2, 3].subIteration(1, 2).toList(), [2]);
      expect([1, 2, 3].subIteration(2, 2).toList(), []);
    });

    test('to2D', () {
      expect(() => [1, 2, 3].to2D(0), throwsA(isA<RangeError>()));
      expect([].to2D(3), []);
      expect(expandedA.to2D(1), twoDimA);
      expect(expandedB.to2D(3), twoDimB);
      expect(expandedC.to2D(2), twoDimC);
    });

    test('groupAsMap', () {
      expect([42].groupAsMap((e) => e), {
        42: [42],
      });
      expect([1, 2, 3, 4].groupAsMap((e) => e.isEven), {
        true: [2, 4],
        false: [1, 3],
      });
    });

    test('firstWhereOrNull', () {
      expect(<int>[].firstWhereOrNull((element) => element > 0), isNull);
      expect([1].firstWhereOrNull((element) => element.isEven), isNull);
      expect([1, 2, 4].firstWhereOrNull((element) => element.isEven), 2);
    });

    test('lastWhereOrNull', () {
      expect(<int>[].lastWhereOrNull((element) => element > 0), isNull);
      expect([1].lastWhereOrNull((element) => element.isEven), isNull);
      expect([1, 2, 4].lastWhereOrNull((element) => element.isEven), 4);
    });
  });

  group('IterableIterableX', () {
    test('from2D', () {
      expect([[]].flatten(), []);
      expect(twoDimA.flatten().toList(), expandedA);
      expect(twoDimB.flatten().toList(), expandedB);
      expect(twoDimC.flatten().toList(), expandedC);
    });
  });

  group('ChronoSortable', () {
    test('earliest', () {
      final es = randomChronoIterable(1000);
      final e = es.earliest((e) => e.dateTime);
      for (final element in es) {
        expect(e.dateTime.isBefore(element.dateTime), e != element);
      }
    });
    test('latest', () {
      final es = randomChronoIterable(1000);
      final e = es.latest((e) => e.dateTime);
      for (final element in es) {
        expect(e.dateTime.isAfter(element.dateTime), e != element);
      }
    });
  });
}

List<ChronoEntity> randomChronoIterable(int length) {
  return List.generate(length, (index) => ChronoEntity(Rand.dateTime()));
}

class ChronoEntity {
  final DateTime dateTime;

  const ChronoEntity(this.dateTime);
}
