import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _cell(int i) => SizedBox.expand(key: ValueKey(i));

Future<void> _pump(
  WidgetTester tester,
  FlexGrid grid, {
  double width = 300,
  double height = 600,
}) {
  return tester.pumpWidget(
    Directionality(
      textDirection: .ltr,
      child: Align(
        alignment: .topLeft,
        child: SizedBox(width: width, height: height, child: grid),
      ),
    ),
  );
}

Rect _rectOf(WidgetTester tester, int i) {
  return tester.getRect(find.byKey(ValueKey(i)));
}

void main() {
  group('FlexGrid layout', () {
    testWidgets('vertical 3-col places children in row-major order', (
      tester,
    ) async {
      await _pump(
        tester,
        FlexGrid(
          crossAxisCount: 3,
          children: List.generate(6, _cell),
        ),
      );

      // 300 / 3 = 100, square aspect → 100x100 each.
      for (var i = 0; i < 6; i++) {
        final r = _rectOf(tester, i);
        final col = i % 3;
        final row = i ~/ 3;
        check(r.size).equals(const Size(100, 100));
        check(r.left).isCloseTo(col * 100.0, 0.01);
        check(r.top).isCloseTo(row * 100.0, 0.01);
      }
    });

    testWidgets('spacing pushes children apart', (tester) async {
      await _pump(
        tester,
        FlexGrid(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: List.generate(4, _cell),
        ),
      );

      // 2 cols × cellWidth + 1 gap of 10 = 300 → cellWidth = 145.
      final r0 = _rectOf(tester, 0);
      final r1 = _rectOf(tester, 1);
      final r2 = _rectOf(tester, 2);

      check(r0.size.width).isCloseTo(145, 0.01);
      check(r1.left - r0.right).isCloseTo(10, 0.01);
      check(r2.top - r0.bottom).isCloseTo(20, 0.01);
    });

    testWidgets('horizontal direction lays out column-major', (tester) async {
      await _pump(
        tester,
        FlexGrid(
          crossAxisCount: 2,
          direction: .horizontal,
          children: List.generate(4, _cell),
        ),
        width: 600,
        height: 300,
      );

      // crossAxis = vertical when direction is horizontal.
      // 300 / 2 = 150 cross extent → square → 150 main.
      final r0 = _rectOf(tester, 0);
      final r1 = _rectOf(tester, 1);
      final r2 = _rectOf(tester, 2);

      check(r0.size).equals(const Size(150, 150));
      // Child 1 is below child 0 (next cross-axis slot).
      check(r1.top - r0.top).isCloseTo(150, 0.01);
      check(r1.left).isCloseTo(r0.left, 0.01);
      // Child 2 starts the next column (next main-axis step).
      check(r2.left - r0.left).isCloseTo(150, 0.01);
      check(r2.top).isCloseTo(r0.top, 0.01);
    });

    testWidgets('padding offsets every child', (tester) async {
      await _pump(
        tester,
        FlexGrid(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: List.generate(2, _cell),
        ),
      );

      final r0 = _rectOf(tester, 0);
      // 300 - 32 padding = 268 / 2 = 134 cell width.
      check(r0.size.width).isCloseTo(134, 0.01);
      check(r0.left).isCloseTo(16, 0.01);
      check(r0.top).isCloseTo(16, 0.01);
    });
  });
}
