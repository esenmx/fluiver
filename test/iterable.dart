import 'package:dashx/dashx.dart';
import 'package:flutter/material.dart';
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

  group('IterableWidgetExtensions', () {
    test('widgetJoin', () {
      expect(widgetJoinMock(0), <Widget>[]);
      expect(widgetJoinMock(1).length, 1);
      expect(widgetJoinMock(1).single, isA<FlutterLogo>());
      expect(widgetJoinMock(2).length, 3);
      expect(widgetJoinMock(2)[0], isA<FlutterLogo>());
      expect(widgetJoinMock(2)[1], isA<Divider>());
      expect(widgetJoinMock(2)[2], isA<FlutterLogo>());
      final values = widgetJoinMock(100);
      for (int i = 0; i < 100; i++) {
        if (i % 2 == 0) {
          expect(values.elementAt(i), isA<FlutterLogo>());
        } else {
          expect(values.elementAt(i), isA<Divider>());
        }
      }
    });

    test('mappedChildren', () {
      expect(mappedChildrenMock(0), <int, Widget>{});
      expect(mappedChildrenMock(1)[0], isA<SizedBox>());
      expect(mappedChildrenMock(1).length, 1);
      final values = mappedChildrenMock(100);
      for (int i = 0; i < 100; i++) {
        expect(values[i], isA<SizedBox>());
      }
    });
  });
}

List<Widget> widgetJoinMock(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .widgetJoin(const Divider())
      .toList();
}

Map<int, Widget> mappedChildrenMock(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const SizedBox()]
      .mappedChildren;
}
