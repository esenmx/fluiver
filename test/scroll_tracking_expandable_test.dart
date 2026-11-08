@Tags(['web'])
library;

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app({
  required bool isExpanded,
  ScrollController? controller,
  double scrollOffset = 0,
  Duration duration = const Duration(milliseconds: 200),
  Curve curve = Curves.easeInOut,
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
              duration: duration,
              curve: curve,
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

Widget _withField(Widget child, {required bool isExpanded}) => MaterialApp(
  home: Scaffold(
    body: Column(
      children: [
        const TextField(key: Key('visible')),
        ScrollTrackingExpandable(isExpanded: isExpanded, child: child),
      ],
    ),
  ),
);

Widget _collapsed(Widget child) => _withField(child, isExpanded: false);

Future<void> _focusNextAfterVisible(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('visible')));
  await tester.pump();
  FocusManager.instance.primaryFocus?.nextFocus();
  await tester.pump();
}

void main() {
  group('ScrollTrackingExpandable', () {
    setUp(() {
      // Headless Chrome reports disableAnimations, which skips the animation.
      final d = TestWidgetsFlutterBinding.instance.platformDispatcher
        ..accessibilityFeaturesTestValue = const FakeAccessibilityFeatures();
      addTearDown(d.clearAccessibilityFeaturesTestValue);
    });

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

    testWidgets('collapsed child is skipped by focus traversal', (
      tester,
    ) async {
      final hidden = FocusNode();
      addTearDown(hidden.dispose);
      await tester.pumpWidget(_collapsed(TextField(focusNode: hidden)));

      await _focusNextAfterVisible(tester);
      check(hidden.hasFocus).isFalse();
    });

    testWidgets('child collapsed after expanding is skipped by focus '
        'traversal', (tester) async {
      final hidden = FocusNode();
      addTearDown(hidden.dispose);
      await tester.pumpWidget(
        _withField(TextField(focusNode: hidden), isExpanded: true),
      );
      await tester.pumpWidget(_collapsed(TextField(focusNode: hidden)));
      await tester.pumpAndSettle();

      await _focusNextAfterVisible(tester);
      check(hidden.hasFocus).isFalse();
    });

    testWidgets('collapsed child tickers are muted', (tester) async {
      var ticks = 0;
      await tester.pumpWidget(
        _collapsed(
          TickerBuilder(
            onTick: (_) => ticks++,
            builder: (_, _) => const SizedBox(),
          ),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      check(ticks).equals(0);
    });

    testWidgets('collapsed child is excluded from semantics', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_collapsed(const Text('secret details')));
        check(find.bySemanticsLabel('secret details').evaluate()).isEmpty();
      } finally {
        handle.dispose();
      }
    });

    testWidgets('expanded child is reachable by focus traversal', (
      tester,
    ) async {
      final shown = FocusNode();
      addTearDown(shown.dispose);
      await tester.pumpWidget(
        _withField(TextField(focusNode: shown), isExpanded: true),
      );

      await _focusNextAfterVisible(tester);
      check(shown.hasFocus).isTrue();
    });

    testWidgets('expanded child tickers run', (tester) async {
      var ticks = 0;
      await tester.pumpWidget(
        _withField(
          TickerBuilder(
            onTick: (_) => ticks++,
            builder: (_, _) => const SizedBox(),
          ),
          isExpanded: true,
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      check(ticks).isGreaterThan(0);
    });

    testWidgets('collapse animates the height down', (tester) async {
      await tester.pumpWidget(_app(isExpanded: true));

      await tester.pumpWidget(_app(isExpanded: false));
      await tester.pump(const Duration(milliseconds: 100));
      check(_size(tester).height)
        ..isGreaterThan(0)
        ..isLessThan(300);
    });

    testWidgets('duration: Duration.zero collapse immediately marks child '
        'offstage on next frame', (tester) async {
      final hidden = FocusNode();
      addTearDown(hidden.dispose);
      Widget build({required bool isExpanded}) => MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const TextField(key: Key('visible')),
              ScrollTrackingExpandable(
                isExpanded: isExpanded,
                duration: .zero,
                child: TextField(focusNode: hidden),
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(build(isExpanded: true));
      await tester.pumpWidget(build(isExpanded: false));
      final offstage = tester.widget<Offstage>(
        find.descendant(
          of: find.byType(ScrollTrackingExpandable),
          matching: find.byType(Offstage),
        ),
      );
      check(offstage.offstage).isTrue();
    });

    testWidgets('duration: Duration.zero expansion reveals the child', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _app(isExpanded: false, controller: controller, duration: .zero),
      );

      await tester.pumpWidget(
        _app(isExpanded: true, controller: controller, duration: .zero),
      );
      await tester.pumpAndSettle();

      check(controller.offset).equals(200);
    });

    testWidgets('mounting expanded does not scroll, whatever the duration', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _app(isExpanded: true, controller: controller, duration: .zero),
      );
      await tester.pumpAndSettle();

      check(controller.offset).equals(0);
    });

    testWidgets(
      'a toggle and curve change during a rejected duration apply once valid',
      (tester) async {
        await tester.pumpWidget(_app(isExpanded: false, curve: Curves.linear));
        await tester.pumpWidget(
          _app(
            isExpanded: true,
            duration: const Duration(milliseconds: -1),
            curve: Curves.easeIn,
          ),
        );
        check(tester.takeException()).isA<ArgumentError>();

        await tester.pumpWidget(_app(isExpanded: true, curve: Curves.easeIn));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        check(_size(tester).height).isLessThan(150);

        await tester.pumpAndSettle();
        check(_size(tester).height).equals(300);
      },
    );

    testWidgets('negative duration reports ArgumentError on mount', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(isExpanded: false, duration: const Duration(milliseconds: -1)),
      );

      check(tester.takeException())
          .isA<ArgumentError>()
          .has((e) => e.name, 'name')
          .equals('duration');
    });

    testWidgets('negative duration reports ArgumentError on update', (
      tester,
    ) async {
      await tester.pumpWidget(_app(isExpanded: false));

      await tester.pumpWidget(
        _app(isExpanded: false, duration: const Duration(milliseconds: -1)),
      );

      check(tester.takeException())
          .isA<ArgumentError>()
          .has((e) => e.name, 'name')
          .equals('duration');
    });

    testWidgets('negative duration reports ArgumentError while toggling', (
      tester,
    ) async {
      await tester.pumpWidget(_app(isExpanded: false));

      await tester.pumpWidget(
        _app(isExpanded: true, duration: const Duration(milliseconds: -1)),
      );

      check(tester.takeException()).isA<ArgumentError>();
    });

    testWidgets('rapid true -> false -> true toggle expands to full height', (
      tester,
    ) async {
      await tester.pumpWidget(_app(isExpanded: true));
      await tester.pumpWidget(_app(isExpanded: false));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(_app(isExpanded: true));
      await tester.pumpAndSettle();

      check(_size(tester).height).equals(300);
      final offstage = tester.widget<Offstage>(
        find.descendant(
          of: find.byType(ScrollTrackingExpandable),
          matching: find.byType(Offstage),
        ),
      );
      check(offstage.offstage).isFalse();
    });
  });
}
