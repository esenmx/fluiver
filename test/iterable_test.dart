import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('separated', () {
    List<Widget> separated(int n) {
      final logos = <Widget>[for (var i = 0; i < n; i++) const FlutterLogo()];
      return logos.separated((_) => const Divider()).toList();
    }

    test('empty', () => check(separated(0)).isEmpty());
    test('single', () {
      final result = separated(1);
      check(result).length.equals(1);
      check(result.single).isA<FlutterLogo>();
    });
    test('two elements', () {
      final result = separated(2);
      check(result).length.equals(3);
      check(result[0]).isA<FlutterLogo>();
      check(result[1]).isA<Divider>();
      check(result[2]).isA<FlutterLogo>();
    });
    test('alternates correctly', () {
      final result = separated(100);
      for (var i = 0; i < result.length; i++) {
        if (i.isEven) {
          check(result[i]).isA<FlutterLogo>();
        } else {
          check(result[i]).isA<Divider>();
        }
      }
    });
  });

  group('windowed', () {
    test('default step yields every overlapping window', () {
      check([1, 2, 3, 4, 5].windowed(3).toList()).deepEquals([
        [1, 2, 3],
        [2, 3, 4],
        [3, 4, 5],
      ]);
    });

    test('custom step skips elements between windows', () {
      check([1, 2, 3, 4, 5].windowed(2, step: 2).toList()).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });

    test('step larger than size skips inputs between windows', () {
      check([1, 2, 3, 4, 5, 6, 7].windowed(2, step: 3).toList()).deepEquals([
        [1, 2],
        [4, 5],
      ]);
    });

    test('drops partial trailing window', () {
      check([1, 2, 3, 4].windowed(3, step: 2).toList()).deepEquals([
        [1, 2, 3],
      ]);
    });

    test('empty when size exceeds length', () {
      check([1, 2].windowed(3).toList()).isEmpty();
    });

    test('size 1 with default step is one window per element', () {
      check([1, 2, 3].windowed(1).toList()).deepEquals([
        [1],
        [2],
        [3],
      ]);
    });

    test('size 0 throws', () {
      check(() => [1, 2, 3].windowed(0).toList()).throws<RangeError>();
    });

    test('step 0 throws', () {
      check(() => [1, 2, 3].windowed(2, step: 0).toList()).throws<RangeError>();
    });

    test('lazy — does not iterate beyond what consumer takes', () {
      var pulls = 0;
      Iterable<int> source() sync* {
        for (var i = 0; i < 1000; i++) {
          pulls++;
          yield i;
        }
      }

      source().windowed(3).take(1).toList();

      check(pulls).equals(3);
    });
  });
}
