import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IterableWidgetX', () {
    test('widgetJoin', () {
      expect(mockWidgetJoin(0), <Widget>[]);
      expect(mockWidgetJoin(1), hasLength(1));
      expect(mockWidgetJoin(1).single, isA<FlutterLogo>());
      expect(mockWidgetJoin(2), hasLength(3));
      expect(mockWidgetJoin(2)[0], isA<FlutterLogo>());
      expect(mockWidgetJoin(2)[1], isA<Divider>());
      expect(mockWidgetJoin(2)[2], isA<FlutterLogo>());
      final values = mockWidgetJoin(100);
      for (int i = 0; i < 100; i++) {
        if (i % 2 == 0) {
          expect(values.elementAt(i), isA<FlutterLogo>());
        } else {
          expect(values.elementAt(i), isA<Divider>());
        }
      }
    });
  });
}

List<Widget> mockWidgetJoin(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .widgetJoin(() => const Divider())
      .toList();
}
