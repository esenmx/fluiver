import 'dart:async';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpList(WidgetTester tester, ScrollController controller) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            controller: controller,
            itemCount: 100,
            itemBuilder: (_, i) => SizedBox(height: 50, child: Text('$i')),
          ),
        ),
      ),
    );
  }

  group('atTop / atBottom — no client', () {
    test('both false when controller has no clients', () {
      final c = ScrollController();
      addTearDown(c.dispose);

      check(c.atTop).isFalse();
      check(c.atBottom).isFalse();
    });
  });

  group('atTop / atBottom — attached', () {
    testWidgets('atTop true after mount, atBottom false', (tester) async {
      final c = ScrollController();
      addTearDown(c.dispose);

      await pumpList(tester, c);

      check(c.atTop).isTrue();
      check(c.atBottom).isFalse();
    });

    testWidgets('atBottom true after jumpTo maxScrollExtent', (tester) async {
      final c = ScrollController();
      addTearDown(c.dispose);

      await pumpList(tester, c);
      c.jumpTo(c.position.maxScrollExtent);
      await tester.pump();

      check(c.atTop).isFalse();
      check(c.atBottom).isTrue();
    });
  });

  group('animateToTop / animateToBottom', () {
    testWidgets('animateToBottom reaches maxScrollExtent', (tester) async {
      final c = ScrollController();
      addTearDown(c.dispose);

      await pumpList(tester, c);
      unawaited(
        c.animateToBottom(duration: const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      check(c.position.pixels).equals(c.position.maxScrollExtent);
    });

    testWidgets('animateToTop reaches minScrollExtent', (tester) async {
      final c = ScrollController();
      addTearDown(c.dispose);

      await pumpList(tester, c);
      c.jumpTo(c.position.maxScrollExtent);
      await tester.pump();

      unawaited(c.animateToTop(duration: const Duration(milliseconds: 100)));
      await tester.pumpAndSettle();

      check(c.position.pixels).equals(c.position.minScrollExtent);
    });

    test('animateToBottom no-op when no client', () async {
      final c = ScrollController();
      addTearDown(c.dispose);

      await c.animateToBottom();
    });
  });
}
