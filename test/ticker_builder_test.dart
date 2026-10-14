import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TickerBuilder', () {
    testWidgets('builds with zero elapsed on first frame', (tester) async {
      Duration? captured;
      await tester.pumpWidget(
        TickerBuilder(
          builder: (context, elapsed) {
            captured = elapsed;
            return const SizedBox.shrink();
          },
        ),
      );
      check(captured).equals(.zero);
    });

    testWidgets('rebuilds on subsequent frames with growing elapsed', (
      tester,
    ) async {
      final samples = <Duration>[];
      await tester.pumpWidget(
        TickerBuilder(
          builder: (context, elapsed) {
            samples.add(elapsed);
            return const SizedBox.shrink();
          },
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
        TickerBuilder(
          onTick: (elapsed) => ticked = elapsed,
          builder: (context, elapsed) => const SizedBox.shrink(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));
      check(ticked).isNotNull();
    });

    testWidgets('enabled: false schedules no frames and never ticks', (
      tester,
    ) async {
      var ticks = 0;
      await tester.pumpWidget(
        TickerBuilder(
          enabled: false,
          onTick: (_) => ticks++,
          builder: (context, elapsed) => const SizedBox.shrink(),
        ),
      );
      check(tester.binding.transientCallbackCount).equals(0);
      await tester.pumpAndSettle();
      check(ticks).equals(0);
    });

    testWidgets('disabling holds elapsed; re-enabling resumes from it', (
      tester,
    ) async {
      var last = Duration.zero;
      Widget app({required bool enabled}) => TickerBuilder(
        enabled: enabled,
        onTick: (elapsed) => last = elapsed,
        builder: (context, elapsed) => const SizedBox.shrink(),
      );

      await tester.pumpWidget(app(enabled: true));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(app(enabled: false));
      final paused = last;
      check(paused.inMicroseconds).isGreaterThan(0);

      await tester.pump(const Duration(seconds: 5));
      check(last).equals(paused);

      await tester.pumpWidget(app(enabled: true));
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 100));
      check(last.inMicroseconds)
        ..isGreaterThan(paused.inMicroseconds)
        ..isLessThan((paused + const Duration(seconds: 1)).inMicroseconds);
    });
  });
}
