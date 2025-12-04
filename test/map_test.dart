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
}
