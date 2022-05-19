import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rand/rand.dart';

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

  group('IterableX', () {
    test('to2D', () {
      expect(() => [1, 2, 3].to2D(0), throwsA(isA<RangeError>()));
      expect([].to2D(3), []);
      expect(expandedA.to2D(1), twoDimA);
      expect(expandedB.to2D(3), twoDimB);
      expect(expandedC.to2D(2), twoDimC);
    });

    test('groupAsMap', () {
      expect([42].groupAsMap((e) => e), {42: [42]});
      expect([1, 2, 3, 4].groupAsMap((e) => e % 2 == 0), {
        true: [2, 4],
        false: [1, 3]
      });
    });
  });

  group('IterableIterableX', () {
    test('from2D', () {
      expect([[]].from2D(), []);
      expect(twoDimA.from2D().toList(), expandedA);
      expect(twoDimB.from2D().toList(), expandedB);
      expect(twoDimC.from2D().toList(), expandedC);
    });
  });

  group('IterableWidgetX', () {
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

    test('asMapBuilder', () {
      expect(mockAsMapBuilder(0), <int, Widget>{});
      expect(mockAsMapBuilder(1)[0], isA<Text>());
      expect(mockAsMapBuilder(1).length, 1);
      final values = mockAsMapBuilder(100);
      for (int i = 0; i < 100; i++) {
        expect(values[i], isA<Text>());
      }
    });
  });

  group('ChronographiclySortable', () {
    test('earliest', () {
      final es = randomChronoIterable(1000);
      final e = es.earliest((e) => e.dateTime);
      for (var element in es) {
        expect(e.dateTime.isBefore(element.dateTime), e != element);
      }
    });
    test('latest', () {
      final es = randomChronoIterable(1000);
      final e = es.latest((e) => e.dateTime);
      for (var element in es) {
        expect(e.dateTime.isAfter(element.dateTime), e != element);
      }
    });
  });
}

List<Widget> mockWidgetJoin(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .widgetJoin(() => const Divider())
      .toList();
}

Map<int, Widget> mockAsMapBuilder(int length) {
  return List.generate(length, (i) => i)
      .asMapBuilder((i) => Text(i.toString()));
}

List<_ChronoEntity> randomChronoIterable(int length) {
  return List.generate(length, (index) => _ChronoEntity(Rand.dateTime()));
}

class _ChronoEntity {
  final DateTime dateTime;

  const _ChronoEntity(this.dateTime);
}
