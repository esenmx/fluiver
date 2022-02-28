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
    test('to2D', () {
      expect([].to2D(3), []);
      expect(expandedA.to2D(1), twoDimA);
      expect(expandedB.to2D(3), twoDimB);
      expect(expandedC.to2D(2), twoDimC);
    });

    test('toIndexedMap', () {
      expect([].toIndexedMap, {});
      expect([false, true].toIndexedMap, {0: false, 1: true});
      expect(['foo', 'bar'].toIndexedMap, {0: 'foo', 1: 'bar'});
    });
  });

  group('Iterable2DExtensions<E>', () {
    test('from2D', () {
      expect([[]].from2D, []);
      expect(twoDimA.from2D.toList(), expandedA);
      expect(twoDimB.from2D.toList(), expandedB);
      expect(twoDimC.from2D.toList(), expandedC);
    });
  });

  group('IterableWidgetExtensions', () {
    test('widgetJoin', () {
      expect(mockWidgetJoin(0), <Widget>[]);
      expect(mockWidgetJoin(1).length, 1);
      expect(mockWidgetJoin(1).single, isA<FlutterLogo>());
      expect(mockWidgetJoin(2).length, 3);
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

    test('mappedChildren', () {
      expect(mockMappedChildren(0), <int, Widget>{});
      expect(mockMappedChildren(1)[0], isA<Text>());
      expect(mockMappedChildren(1).length, 1);
      final values = mockMappedChildren(100);
      for (int i = 0; i < 100; i++) {
        expect(values[i], isA<Text>());
      }
    });
  });
}

List<Widget> mockWidgetJoin(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .widgetJoin(const Divider())
      .toList();
}

Map<int, Widget> mockMappedChildren(int length) {
  return List.generate(length, (i) => i)
      .mappedChildren((i) => Text(i.toString()));
}
