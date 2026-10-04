import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_helpers.dart';

void main() {
  group('atTop / atBottom — no client', () {
    test('both false when controller has no clients', () {
      final c = newScrollController();

      check(c.atTop).isFalse();
      check(c.atBottom).isFalse();
    });
  });

  group('atTop / atBottom — attached', () {
    testWidgets('atTop true after mount, atBottom false', (tester) async {
      final c = newScrollController();

      await pumpScrollableList(tester, c);

      check(c.atTop).isTrue();
      check(c.atBottom).isFalse();
    });

    testWidgets('atBottom true after jumpTo maxScrollExtent', (tester) async {
      final c = newScrollController();

      await pumpScrollableList(tester, c);
      c.jumpTo(c.position.maxScrollExtent);
      await tester.pump();

      check(c.atTop).isFalse();
      check(c.atBottom).isTrue();
    });
  });

  group('animateToTop / animateToBottom', () {
    testWidgets('animateToBottom reaches maxScrollExtent', (tester) async {
      final c = newScrollController();

      await pumpScrollableList(tester, c);
      c.animateToBottom(duration: const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      check(c.position.pixels).equals(c.position.maxScrollExtent);
    });

    testWidgets('animateToTop reaches minScrollExtent', (tester) async {
      final c = newScrollController();

      await pumpScrollableList(tester, c);
      c.jumpTo(c.position.maxScrollExtent);
      await tester.pump();

      c.animateToTop(duration: const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      check(c.position.pixels).equals(c.position.minScrollExtent);
    });

    test('animateToBottom no-op when no client', () async {
      final c = newScrollController();

      await c.animateToBottom();
    });
  });

  group('several attached views', () {
    Future<void> pumpTwoViews(
      WidgetTester tester,
      ScrollController c, {
      double first = 2000,
      double second = 2000,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              for (final height in [first, second])
                Expanded(
                  child: ListView(
                    controller: c,
                    children: [SizedBox(height: height)],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    testWidgets('atTop is safe with two attached scroll views', (tester) async {
      final c = newScrollController();

      await pumpTwoViews(tester, c);

      check(() => c.atTop).returnsNormally();
    });

    testWidgets('edge helpers cover every attached view', (tester) async {
      final c = newScrollController();

      await pumpTwoViews(tester, c, second: 3000);
      check(c.atTop).isTrue();
      check(c.atBottom).isFalse();

      c.animateToBottom(duration: const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      check(c.atBottom).isTrue();
      check(c.atTop).isFalse();

      c.animateToTop(duration: const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      check(c.atTop).isTrue();
      check(c.atBottom).isFalse();
    });

    testWidgets('only the first view at the bottom is at neither edge', (
      tester,
    ) async {
      final c = newScrollController();

      await pumpTwoViews(tester, c, second: 3000);
      final first = c.positions.first;
      first.jumpTo(first.maxScrollExtent);
      await tester.pump();

      check(c.atBottom).isFalse();
      check(c.atTop).isFalse();
    });

    testWidgets('only the last view at the bottom is at neither edge', (
      tester,
    ) async {
      final c = newScrollController();

      await pumpTwoViews(tester, c, second: 3000);
      final last = c.positions.last;
      last.jumpTo(last.maxScrollExtent);
      await tester.pump();

      check(c.atBottom).isFalse();
      check(c.atTop).isFalse();
    });
  });
}
