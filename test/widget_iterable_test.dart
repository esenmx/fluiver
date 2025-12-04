import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('separate', () {
    List<Widget> separated(int n) {
      return <Widget>[for (var i = 0; i < n; i++) const FlutterLogo()]
          .separate(() => const Divider())
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

  group('slicedWidgetsBuilder', () {
    List<DateTime> dateSeries(int length) {
      return List.generate(
        length,
        (i) => DateTime.now().subtract(Duration(hours: i)),
      );
    }

    testWidgets('empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(0).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
              );
              check(result).isEmpty();
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('24 hours spans 2 days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(24).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
              );
              check(result).length.equals(24 + 2);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('100 hours spans 5 days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(100).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
              );
              check(result).length.equals(100 + 5);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('with separator empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(0).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
                separatorBuilder: (_) => const Divider(),
              );
              check(result).isEmpty();
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('with separator 24h', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(24).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
                separatorBuilder: (_) => const Divider(),
              );
              check(result).length.equals(26 + 22);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('with separator 100h', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = dateSeries(100).slicedWidgetsBuilder<DateTime>(
                context: context,
                valueWidgetBuilder: (_, val, __) => Text(val.toString()),
                toSlicer: (e) => e.truncateTime(),
                slicerBuilder: (_, slicer) => Text(slicer.toString()),
                separatorBuilder: (_) => const Divider(),
              );
              check(result).length.equals(105 + 95);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
