import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app({
  required bool isExpanded,
  ScrollController? controller,
  double scrollOffset = 0,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            const SizedBox(height: 500),
            ScrollTrackingExpandable(
              isExpanded: isExpanded,
              scrollOffset: scrollOffset,
              child: const SizedBox(height: 300, width: 100),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
  );
}

Size _size(WidgetTester tester) =>
    tester.getSize(find.byType(ScrollTrackingExpandable));

void main() {
  group('ScrollTrackingExpandable', () {
    testWidgets('starts collapsed at zero height', (tester) async {
      await tester.pumpWidget(_app(isExpanded: false));

      check(_size(tester).height).equals(0);
    });

    testWidgets('starts expanded at full child height', (tester) async {
      await tester.pumpWidget(_app(isExpanded: true));

      check(_size(tester).height).equals(300);
    });

    testWidgets('animates height when isExpanded toggles', (tester) async {
      await tester.pumpWidget(_app(isExpanded: false));

      await tester.pumpWidget(_app(isExpanded: true));
      await tester.pump(const Duration(milliseconds: 100));
      check(_size(tester).height)
        ..isGreaterThan(0)
        ..isLessThan(300);
      await tester.pumpAndSettle();
      check(_size(tester).height).equals(300);

      await tester.pumpWidget(_app(isExpanded: false));
      await tester.pumpAndSettle();
      check(_size(tester).height).equals(0);
    });

    testWidgets('tracks bottom edge during expansion and lands fully '
        'visible', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_app(isExpanded: false, controller: controller));
      check(controller.offset).equals(0);

      await tester.pumpWidget(_app(isExpanded: true, controller: controller));
      await tester.pump(const Duration(milliseconds: 100));
      check(controller.offset)
        ..isGreaterThan(0)
        ..isLessThan(200);
      await tester.pumpAndSettle();
      // Expanded bottom edge sits at 500 + 300 in a 600-tall viewport.
      check(controller.offset).equals(200);
    });

    testWidgets('scrollOffset reveals extra space below the bottom edge', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _app(isExpanded: false, controller: controller, scrollOffset: 50),
      );

      await tester.pumpWidget(
        _app(isExpanded: true, controller: controller, scrollOffset: 50),
      );
      await tester.pumpAndSettle();
      check(controller.offset).equals(250);
    });
  });
}
