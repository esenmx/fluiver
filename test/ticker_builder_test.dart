import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TickerBuilder', () {
    testWidgets('builds with zero elapsed on first frame', (tester) async {
      Duration? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: TickerBuilder(
            builder: (context, elapsed) {
              captured = elapsed;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      check(captured).equals(Duration.zero);
    });

    testWidgets('rebuilds on subsequent frames with growing elapsed', (
      tester,
    ) async {
      final samples = <Duration>[];
      await tester.pumpWidget(
        MaterialApp(
          home: TickerBuilder(
            builder: (context, elapsed) {
              samples.add(elapsed);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      check(samples.length).isGreaterThan(1);
      check(samples.last.inMicroseconds).isGreaterThan(0);
    });

    testWidgets('calls onTick callback', (tester) async {
      Duration? ticked;
      await tester.pumpWidget(
        MaterialApp(
          home: TickerBuilder(
            onTick: (elapsed) => ticked = elapsed,
            builder: (context, elapsed) => const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));
      check(ticked).isNotNull();
    });
  });
}
