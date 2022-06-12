import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

  group('WidgetIterableX', () {
    test('slicedWidgetBuilder', () {
      dateSeries(int length) {
        return List.generate(length, (index) {
          return DateTime.now().subtract(Duration(hours: index));
        });
      }

      newCase(int length, bool withSeparator) {
        return dateSeries(length).slicedWidgetBuilder<DateTime>(
          context: MockBuildContext(),
          widgetBuilder: (_, val, __) => Text(val.toString()),
          toSlicer: (DateTime e) => e.toDate(),
          slicerBuilder: (_, slicer) => Text(slicer.toString()),
          child: const FlutterLogo(),
          separatorBuilder: withSeparator ? (context) => const Divider() : null,
        );
      }

      expect(newCase(0, false), isEmpty);
      expect(newCase(24, false), hasLength(24 + 2));
      expect(newCase(100, false), hasLength(100 + 5));

      expect(newCase(0, true), isEmpty);
      expect(newCase(24, true), hasLength(26 + 22));
      expect(newCase(100, true), hasLength(105 + 95));
    });
  });
}

List<Widget> mockWidgetJoin(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .widgetJoin(() => const Divider())
      .toList();
}

class MockBuildContext extends Mock implements BuildContext {}
