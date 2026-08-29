import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _cell(int i) => SizedBox.expand(key: ValueKey(i));

Future<void> _pump(
  WidgetTester tester,
  Grid grid, {
  double width = 300,
  double height = 600,
  TextDirection textDirection = .ltr,
}) {
  return tester.pumpWidget(
    Directionality(
      textDirection: textDirection,
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

/// Bare [SliverGridDelegate] — neither built-in subclass — so the
/// intrinsic path has no `crossAxisCount` to read and must fall back.
class _RegularTileDelegate extends SliverGridDelegate {
  const _RegularTileDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return const SliverGridRegularTileLayout(
      crossAxisCount: 2,
      mainAxisStride: 50,
      crossAxisStride: 50,
      childMainAxisExtent: 50,
      childCrossAxisExtent: 50,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(_RegularTileDelegate oldDelegate) => false;
}

void main() {
  group('Grid layout', () {
    testWidgets('vertical 3-col places children in row-major order', (
      tester,
    ) async {
      await _pump(
        tester,
        .count(crossAxisCount: 3, children: .generate(6, _cell)),
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
        .count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: .generate(4, _cell),
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
        .count(
          crossAxisCount: 2,
          direction: .horizontal,
          children: .generate(4, _cell),
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
        .count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: .generate(2, _cell),
        ),
      );

      final r0 = _rectOf(tester, 0);
      // 300 - 32 padding = 268 / 2 = 134 cell width.
      check(r0.size.width).isCloseTo(134, 0.01);
      check(r0.left).isCloseTo(16, 0.01);
      check(r0.top).isCloseTo(16, 0.01);
    });

    testWidgets('extent constructor picks column count from width', (
      tester,
    ) async {
      await _pump(
        tester,
        .extent(
          maxCrossAxisExtent: 100,
          children: .generate(4, _cell),
        ),
      );

      // 300 / max 100 → 3 columns of exactly 100.
      check(_rectOf(tester, 0).size).equals(const Size(100, 100));
      check(_rectOf(tester, 1).left).isCloseTo(100, 0.01);
      check(_rectOf(tester, 3).top).isCloseTo(100, 0.01);
    });

    testWidgets('vertical grid reverses columns under RTL', (tester) async {
      await _pump(
        tester,
        .count(crossAxisCount: 2, children: .generate(2, _cell)),
        textDirection: .rtl,
      );

      // GridView parity: first child occupies the trailing (right) half.
      check(_rectOf(tester, 0).left).isCloseTo(150, 0.01);
      check(_rectOf(tester, 1).left).isCloseTo(0, 0.01);
    });

    testWidgets('Grid rtl direction', (tester) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 3,
          children: .generate(3, _cell),
        ),
        textDirection: .rtl,
      );

      // 300 wide, 3 columns -> each is 100 wide.
      // Under RTL, child 0 should be on the right (left = 200)
      // child 1 should be in the middle (left = 100)
      // child 2 should be on the left (left = 0)
      check(_rectOf(tester, 0).left).isCloseTo(200, 0.01);
      check(_rectOf(tester, 1).left).isCloseTo(100, 0.01);
      check(_rectOf(tester, 2).left).isCloseTo(0, 0.01);
    });

    testWidgets('intrinsic dimensions match layout calculations', (
      tester,
    ) async {
      final grid = Grid.count(
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: const [
          SizedBox(width: 50, height: 50),
          SizedBox(width: 50, height: 50),
          SizedBox(width: 50, height: 50),
        ],
      );
      await _pump(tester, grid);
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      // Available width: 300.
      // Child cross-axis extent: (300 - 10) / 2 = 145.
      // Child main-axis extent: 145 / 2 = 72.5.
      // Row count: 2 (3 children).
      // Total height: 2 * 72.5 + 10 = 155.0.
      check(renderBox.getMinIntrinsicHeight(300)).isCloseTo(155.0, 0.01);
      check(renderBox.getMaxIntrinsicHeight(300)).isCloseTo(155.0, 0.01);
    });

    testWidgets('min and max intrinsic width diverge with child intrinsics', (
      tester,
    ) async {
      // Wrap: min intrinsic width = widest child (40), max = sum (70).
      Widget cell() => const Wrap(
        children: [
          SizedBox(width: 30, height: 10),
          SizedBox(width: 40, height: 10),
        ],
      );
      await _pump(
        tester,
        .count(crossAxisCount: 2, children: [cell(), cell()]),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      check(renderBox.getMinIntrinsicWidth(.infinity)).equals(80);
      check(renderBox.getMaxIntrinsicWidth(.infinity)).equals(140);
    });

    testWidgets('intrinsic height for unbounded width shrink-wraps children', (
      tester,
    ) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          children: .generate(
            4,
            (i) => const SizedBox(width: 40, height: 10),
          ),
        ),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      // Fallback cross extent: 2 × 40 = 80 → 40-wide square cells,
      // 2 rows → 80. No hard-coded estimate involved.
      check(renderBox.getMinIntrinsicHeight(.infinity)).equals(80);
      check(renderBox.getMaxIntrinsicHeight(.infinity)).equals(80);
    });

    testWidgets('dry layout matches real layout without laying out children', (
      tester,
    ) async {
      final grid = Grid.count(
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: const [
          SizedBox(width: 50, height: 50),
          SizedBox(width: 50, height: 50),
          SizedBox(width: 50, height: 50),
        ],
      );
      await _pump(tester, grid);
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      check(
        renderBox.getDryLayout(const BoxConstraints(maxWidth: 300)),
      ).equals(const Size(300, 155));
    });

    testWidgets('mainAxisExtent overrides childAspectRatio', (tester) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisExtent: 40,
          children: .generate(2, _cell),
        ),
      );

      // 300 / 2 = 150 wide; 40 main-axis extent wins over ratio (75).
      check(_rectOf(tester, 0).size).equals(const Size(150, 40));
    });

    testWidgets('unbounded cross axis reports a FlutterError', (tester) async {
      await _pump(
        tester,
        .count(crossAxisCount: 2, children: .generate(2, _cell)),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      // Same guard covers performLayout; dry layout throws it without the
      // child-layout error cascade a real layout pass produces.
      check(
        () => renderBox.getDryLayout(const BoxConstraints()),
      ).throws<FlutterError>();
    });

    testWidgets('degenerate constraints clamp cells to zero, not negative', (
      tester,
    ) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: .generate(2, _cell),
        ),
        width: 20,
      );

      check(tester.takeException()).isNull();
      check(_rectOf(tester, 0).width).equals(0);
    });

    testWidgets('dry baseline matches laid-out baseline', (tester) async {
      await _pump(
        tester,
        .count(crossAxisCount: 2, children: const [Text('x'), Text('y')]),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      final dry = renderBox.getDryBaseline(
        .tight(const Size(300, 600)),
        .alphabetic,
      );

      // getDistanceToBaseline is parent-layout-only; the framework's own
      // tests read it post-layout behind this debug flag.
      final double? actual;
      RenderObject.debugCheckingIntrinsics = true;
      try {
        actual = renderBox.getDistanceToBaseline(.alphabetic);
      } finally {
        RenderObject.debugCheckingIntrinsics = false;
      }
      check(dry)
        ..isNotNull()
        ..equals(actual);
    });

    testWidgets('horizontal grid anchors to the trailing edge under RTL', (
      tester,
    ) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          direction: .horizontal,
          children: .generate(4, _cell),
        ),
        width: 600,
        height: 300,
        textDirection: .rtl,
      );

      // 300 / 2 = 150 cross extent → square → 150 main. Content is
      // 2 columns = 300, right-anchored in the 600-wide box (GridView
      // parity): first column occupies [450, 600].
      check(_rectOf(tester, 0).left).isCloseTo(450, 0.01);
      check(_rectOf(tester, 2).left).isCloseTo(300, 0.01);
      // Cross axis (vertical) is unaffected by the RTL flip.
      check(_rectOf(tester, 1).top - _rectOf(tester, 0).top).isCloseTo(
        150,
        0.01,
      );
      check(_rectOf(tester, 1).left).isCloseTo(450, 0.01);
    });

    testWidgets('empty grid collapses to padding', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Align(
            alignment: .topLeft,
            child: SizedBox(
              width: 300,
              child: Grid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      check(tester.takeException()).isNull();
      check(renderBox.size).equals(const Size(300, 16));
      // Padding only — no phantom crossAxisSpacing from an empty child list.
      check(renderBox.getMinIntrinsicWidth(.infinity)).equals(16);
      check(renderBox.getMaxIntrinsicWidth(.infinity)).equals(16);
    });

    testWidgets('delegate swap relayouts through shouldRelayout', (
      tester,
    ) async {
      Grid gridWith(int count) => Grid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
        ),
        children: .generate(4, _cell),
      );

      await _pump(tester, gridWith(3));
      check(_rectOf(tester, 0).width).isCloseTo(100, 0.01);

      await _pump(tester, gridWith(2));
      check(_rectOf(tester, 0).width).isCloseTo(150, 0.01);
    });

    testWidgets('routes taps to the child under the pointer', (tester) async {
      final taps = <int>[];
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          children: [
            for (var i = 0; i < 4; i++)
              GestureDetector(
                key: ValueKey(i),
                behavior: .opaque,
                onTap: () => taps.add(i),
              ),
          ],
        ),
      );

      await tester.tap(find.byKey(const ValueKey(3)));
      check(taps).deepEquals([3]);
    });

    testWidgets('directional padding resolves against ambient direction', (
      tester,
    ) async {
      await _pump(
        tester,
        .count(
          crossAxisCount: 2,
          padding: const EdgeInsetsDirectional.only(start: 16),
          children: .generate(2, _cell),
        ),
        textDirection: .rtl,
      );

      // start = right under RTL: content spans [0, 284], first child
      // takes the trailing (right) half of it.
      final r0 = _rectOf(tester, 0);
      check(r0.width).isCloseTo(142, 0.01);
      check(r0.left).isCloseTo(142, 0.01);
      check(r0.right).isCloseTo(284, 0.01);
    });
  });

  // Regression for the #26 "dead code" removal: every delegate other than
  // SliverGridDelegateWithFixedCrossAxisCount reaches the
  // widest-single-cell branch of RenderGrid._crossIntrinsicFromChildren.
  // Casting there throws for Grid.extent and any custom delegate.
  group('delegate fallback intrinsics', () {
    List<Widget> cells() => .generate(
      4,
      (i) => const SizedBox(width: 40, height: 10),
    );

    testWidgets('Grid.extent cross intrinsics are the widest child', (
      tester,
    ) async {
      await _pump(
        tester,
        .extent(
          maxCrossAxisExtent: 100,
          padding: const EdgeInsets.all(8),
          children: cells(),
        ),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      // 40 widest child + 16 cross padding.
      check(renderBox.getMinIntrinsicWidth(.infinity)).equals(56);
      check(renderBox.getMaxIntrinsicWidth(.infinity)).equals(56);
    });

    testWidgets('Grid.extent main intrinsic for unbounded cross resolves', (
      tester,
    ) async {
      await _pump(
        tester,
        .extent(maxCrossAxisExtent: 100, children: cells()),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      // Routes through _unboundedCrossFallback: cross = 40 → one
      // 40-wide column, four rows of 40 (aspect ratio 1) = 160.
      check(renderBox.getMinIntrinsicHeight(.infinity)).equals(160);
    });

    testWidgets('horizontal Grid.extent cross intrinsic is the tallest child', (
      tester,
    ) async {
      await _pump(
        tester,
        .extent(
          maxCrossAxisExtent: 100,
          direction: .horizontal,
          children: cells(),
        ),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      check(renderBox.getMinIntrinsicHeight(.infinity)).equals(10);
    });

    testWidgets('custom SliverGridDelegate falls back to the widest child', (
      tester,
    ) async {
      await _pump(
        tester,
        Grid(gridDelegate: const _RegularTileDelegate(), children: cells()),
      );
      final renderBox = tester.renderObject<RenderGrid>(find.byType(Grid));

      check(renderBox.getMinIntrinsicWidth(.infinity)).equals(40);
    });

    testWidgets('IntrinsicWidth over Grid.extent lays out without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: .ltr,
          child: Align(
            alignment: .topLeft,
            child: IntrinsicWidth(
              child: Grid.extent(maxCrossAxisExtent: 100, children: cells()),
            ),
          ),
        ),
      );

      check(tester.takeException()).isNull();
    });
  });
}
