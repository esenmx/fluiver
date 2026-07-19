import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final map = {0: false, 1: true, 'foo': 'bar', 'baz': null};

  group('whereKeyType', () {
    test('Object keeps all', () {
      check(map.whereKeyType<Object?>()).deepEquals(map);
    });
    test('int filters', () {
      check(map.whereKeyType<int>()).deepEquals({0: false, 1: true});
    });
    test('no match returns empty', () {
      check(map.whereKeyType<List<dynamic>>()).deepEquals({});
    });
  });

  group('whereValueType', () {
    test('bool filters', () {
      check(map.whereValueType<bool>()).deepEquals({0: false, 1: true});
    });
    test('String filters', () {
      check(map.whereValueType<String>()).deepEquals({'foo': 'bar'});
    });
    test('no match returns empty', () {
      check(map.whereValueType<List<dynamic>>()).deepEquals({});
    });
  });

  group('where', () {
    test('keeps matching entries', () {
      check(map.where((k, v) => k is int)).deepEquals({0: false, 1: true});
    });

    test('keeps entries whose value is null', () {
      check(map.where((k, v) => v == null)).deepEquals({'baz': null});
    });

    test('no match returns empty', () {
      check(map.where((k, v) => false)).deepEquals({});
    });

    test('preserves insertion order', () {
      final ordered = {3: 'c', 1: 'a', 2: 'b', 0: 'z'};
      check(ordered.where((k, v) => k < 3).keys).deepEquals([1, 2, 0]);
    });
  });

  group('entryOf', () {
    test('returns entry for present non-null value', () {
      final entry = map.entryOf('foo')!;
      check(entry.key).equals('foo');
      check(entry.value).equals('bar');
    });

    test('returns entry for present null value', () {
      final entry = map.entryOf('baz');
      check(entry).isNotNull();
      check(entry!.key).equals('baz');
      check(entry.value).isNull();
    });

    test('returns null for absent key', () {
      check(map.entryOf('absent')).isNull();
    });
  });

  group('any / every / firstWhereOrNull', () {
    test('any matches', () {
      check({1: 'a', 2: 'b'}.any((k, v) => v == 'b')).isTrue();
      check({1: 'a', 2: 'b'}.any((k, v) => v == 'c')).isFalse();
    });

    test('every matches', () {
      check({1: 'a', 2: 'b'}.every((k, v) => k > 0)).isTrue();
      check({1: 'a', 2: 'b'}.every((k, v) => k > 1)).isFalse();
    });

    test('firstWhereOrNull returns null on no match', () {
      check({1: 'a'}.firstWhereOrNull((k, v) => k == 2)).isNull();
    });

    test('firstWhereOrNull returns matched entry', () {
      final entry = {1: 'a', 2: 'b'}.firstWhereOrNull((k, v) => v == 'b')!;
      check(entry.key).equals(2);
      check(entry.value).equals('b');
    });
  });
}
