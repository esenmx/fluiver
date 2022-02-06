import 'package:dashx/dashx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('String', () {
    test('capitalize', () {
      expect('', ''.capitalize);
      expect('A', 'a'.capitalize);
      expect('Dashx', 'dashx'.capitalize);
    });

    test('capitalizeEach', () {
      expect('', ''.capitalizeEach());
      expect('A', 'a'.capitalizeEach());
      expect('Dart Go', 'dart go'.capitalizeEach());
      expect('Dart,Go', 'dart,,go'.capitalizeEach(','));
    });
  });
}
