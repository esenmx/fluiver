import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('whereKeyType', () {
    expect(map, map.whereKeyType<Object?>());
    expect(map, map.whereKeyType());
    expect({0: false, 1: true}, map.whereKeyType<int>());
    expect({}, map.whereKeyType<List>());
  });

  test('whereValueType', () {
    expect(map..remove('baz'), map.whereValueType<Object>());
    expect(map, map.whereValueType());
    expect({0: false, 1: true}, map.whereValueType<bool>());
    expect({}, map.whereKeyType<List>());
  });
}

Map get map => {0: false, 1: true, 'foo': 'bar', 'baz': null};
