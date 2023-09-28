import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('IterableWidgetX', () {
    test('separate', () {
      expect(mockSeparate(0), <Widget>[]);
      expect(mockSeparate(1), hasLength(1));
      expect(mockSeparate(1).single, isA<FlutterLogo>());
      expect(mockSeparate(2), hasLength(3));
      expect(mockSeparate(2)[0], isA<FlutterLogo>());
      expect(mockSeparate(2)[1], isA<Divider>());
      expect(mockSeparate(2)[2], isA<FlutterLogo>());
      final values = mockSeparate(100);
      for (int i = 0; i < 100; i++) {
        if (i.isEven) {
          expect(values.elementAt(i), isA<FlutterLogo>());
        } else {
          expect(values.elementAt(i), isA<Divider>());
        }
      }
    });
  });

  group('WidgetIterableX', () {
    test('slicedWidgetBuilder', () {
      List<DateTime> dateSeries(int length) {
        return List.generate(length, (index) {
          return DateTime.now().subtract(Duration(hours: index));
        });
      }

      Iterable<Widget> newCase(int length, bool withSeparator) {
        return dateSeries(length).slicedWidgetsBuilder<DateTime>(
          context: MockBuildContext(),
          valueWidgetBuilder: (_, val, __) => Text(val.toString()),
          toSlicer: (DateTime e) => e.truncateTime(),
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

List<Widget> mockSeparate(int length) {
  return <Widget>[for (int i = 0; i < length; i++) const FlutterLogo()]
      .separate(() => const Divider())
      .toList();
}

class MockBuildContext extends Mock implements BuildContext {}
