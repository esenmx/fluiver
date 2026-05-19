import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaddedFlex', () {
    testWidgets('wraps Flex in Padding with given EdgeInsets', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PaddedFlex(
            direction: Axis.vertical,
            padding: EdgeInsets.all(8),
            children: [SizedBox(width: 10, height: 10)],
          ),
        ),
      );

      check(find.byType(Padding).evaluate()).isNotEmpty();
      check(find.byType(Flex).evaluate()).length.equals(1);

      final padding = tester.widget<Padding>(find.byType(Padding));
      check(padding.padding).equals(const EdgeInsets.all(8));
    });

    testWidgets('respects ambient Directionality (no hardcoded LTR)', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: PaddedRow(
            padding: EdgeInsets.zero,
            children: [SizedBox(width: 10), SizedBox(width: 20)],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      check(flex.textDirection).isNull();
    });

    testWidgets('PaddedColumn lays out children vertically', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PaddedColumn(
            padding: EdgeInsets.zero,
            children: [SizedBox(width: 10, height: 10)],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      check(flex.direction).equals(Axis.vertical);
    });

    testWidgets('PaddedRow lays out children horizontally', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PaddedRow(
            padding: EdgeInsets.zero,
            children: [SizedBox(width: 10, height: 10)],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      check(flex.direction).equals(Axis.horizontal);
    });
  });
}
