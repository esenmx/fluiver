import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('separated', () {
    List<Widget> separated(int n) {
      return <Widget>[for (var i = 0; i < n; i++) const FlutterLogo()]
          .separated(() => const Divider())
          .toList();
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
}
