import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rand/rand.dart';

void main() {
  group('subIteration', () {
    test('invalid start throws', () {
      check(() => <int>[].subIteration(1)).throws<RangeError>();
    });
    test('invalid end throws', () {
      check(() => <int>[].subIteration(0, 2)).throws<RangeError>();
    });
    test('empty range', () {
      check(<int>[].subIteration(0, 0).toList()).deepEquals(<int>[]);
    });
    test('full range', () {
      check([1, 2, 3].subIteration(0).toList()).deepEquals([1, 2, 3]);
    });
    test('from index', () {
      check([1, 2, 3].subIteration(1).toList()).deepEquals([2, 3]);
    });
    test('range', () {
      check([1, 2, 3].subIteration(1, 2).toList()).deepEquals([2]);
    });
  });

  group('to2D', () {
    test('invalid div throws', () {
      check(() => [1, 2, 3].to2D(0)).throws<RangeError>();
    });
    test('empty', () {
      check(<int>[].to2D(3).toList()).deepEquals(<List<int>>[]);
    });
    test('div 1', () {
      check([1, 2].to2D(1).toList()).deepEquals([
        [1],
        [2],
      ]);
    });
    test('div 2', () {
      check([1, 2, 3, 4].to2D(2).toList()).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
    test('uneven', () {
      check([1, 2, 3, 4].to2D(3).toList()).deepEquals([
        [1, 2, 3],
        [4],
      ]);
    });
  });

  group('groupAsMap', () {
    test('single element', () {
      check([42].groupAsMap((e) => e)).deepEquals({
        42: [42],
      });
    });
    test('by predicate', () {
      check([1, 2, 3, 4].groupAsMap((e) => e.isEven)).deepEquals({
        true: [2, 4],
        false: [1, 3],
      });
    });
  });

  group('firstWhereOrNull', () {
    test('empty returns null', () {
      check(<int>[].firstWhereOrNull((e) => e > 0)).isNull();
    });
    test('no match returns null', () {
      check([1].firstWhereOrNull((e) => e.isEven)).isNull();
    });
    test('returns first match', () {
      check([1, 2, 4].firstWhereOrNull((e) => e.isEven)).equals(2);
    });
  });

  group('lastWhereOrNull', () {
    test('empty returns null', () {
      check(<int>[].lastWhereOrNull((e) => e > 0)).isNull();
    });
    test('no match returns null', () {
      check([1].lastWhereOrNull((e) => e.isEven)).isNull();
    });
    test('returns last match', () {
      check([1, 2, 4].lastWhereOrNull((e) => e.isEven)).equals(4);
    });
  });

  group('flatten', () {
    test('empty nested', () {
      check(<List<int>>[[]].flatten().toList()).deepEquals(<int>[]);
    });
    test('single level', () {
      check(
        [
          [1],
          [2],
        ].flatten().toList(),
      ).deepEquals([1, 2]);
    });
    test('multiple elements', () {
      check(
        [
          [1, 2, 3],
          [4],
        ].flatten().toList(),
      ).deepEquals([1, 2, 3, 4]);
    });
  });

  group('ChronoIterable', () {
    List<_ChronoEntity> randomEntities(int n) {
      return List.generate(n, (_) => _ChronoEntity(Rand.dateTime()));
    }

    test('earliest', () {
      final entities = randomEntities(100);
      final earliest = entities.earliest((e) => e.dateTime);
      for (final e in entities) {
        if (e != earliest) {
          check(earliest.dateTime.isBefore(e.dateTime)).isTrue();
        }
      }
    });

    test('latest', () {
      final entities = randomEntities(100);
      final latest = entities.latest((e) => e.dateTime);
      for (final e in entities) {
        if (e != latest) {
          check(latest.dateTime.isAfter(e.dateTime)).isTrue();
        }
      }
    });
  });
}

class _ChronoEntity {
  const _ChronoEntity(this.dateTime);
  final DateTime dateTime;
}
