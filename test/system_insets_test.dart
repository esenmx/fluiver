import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _field = Key('field');
const _bar = Key('bar');
const _keyboards = [0.0, 20.0, 300.0];

/// 400x800 at dpr 1: a 47 status bar, a 34 home indicator and a [keyboard];
/// `padding` is net of the keyboard, as the engine reports it.
void _view(
  WidgetTester tester, {
  double keyboard = 0,
  double top = 47,
  double left = 0,
}) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(400, 800)
    ..viewPadding = FakeViewPadding(left: left, top: top, bottom: 34)
    ..padding = FakeViewPadding(
      left: left,
      top: top,
      bottom: math.max(0, 34 - keyboard),
    )
    ..viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);
}

/// Where a field clears both the keyboard and the home indicator.
double _clear(double keyboard) => 800 - math.max(keyboard, 34);

double _fieldBottom(WidgetTester tester) =>
    tester.getBottomLeft(find.byKey(_field)).dy;

const _fieldBox = SizedBox(key: _field, height: 50);

const _bottomField = Align(alignment: .bottomCenter, child: _fieldBox);

const _safeBottomField = SafeArea(top: false, child: _bottomField);

Widget _withWidget(Widget child) => ViewInsetsPadding(child: child);

Widget _without(Widget child) => child;

/// [ViewInsetsPadding]'s structure with another bottom-padding formula.
class const _Twin(
  final double Function(MediaQueryData data) bottom, {
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: data.viewInsets,
      child: MediaQuery(
        data: data
            .removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
            )
            .copyWith(padding: data.padding.copyWith(bottom: bottom(data))),
        child: child,
      ),
    );
  }
}

Widget _noCorrection(Widget child) =>
    _Twin((data) => data.padding.bottom, child: child);

Widget _subtract(Widget child) => _Twin(
  (data) => math.max(0, data.padding.bottom - data.viewInsets.bottom),
  child: child,
);

Widget _clamp(Widget child) => _Twin(
  (data) => math.min(
    data.padding.bottom,
    math.max(0, data.viewPadding.bottom - data.viewInsets.bottom),
  ),
  child: child,
);

Future<void> _showSheet(WidgetTester tester, WidgetBuilder builder) async {
  await tester.pumpWidget(const MaterialApp(home: Scaffold()));
  showModalBottomSheet<void>(
    context: tester.element(find.byType(Scaffold)),
    isScrollControlled: true,
    builder: builder,
  );
  await tester.pumpAndSettle();
}

Widget _page(Widget body, {bool resize = true}) => MaterialApp(
  home: Scaffold(resizeToAvoidBottomInset: resize, body: body),
);

Widget _composerPage(
  Widget Function(Widget child) wrap, {
  required bool resize,
}) => MaterialApp(
  home: Scaffold(
    resizeToAvoidBottomInset: resize,
    body: const SizedBox.expand(),
    bottomNavigationBar: wrap(
      const SafeArea(top: false, child: SizedBox(key: _field, height: 56)),
    ),
  ),
);

Widget _plainBar() =>
    const SafeArea(key: _bar, top: false, child: SizedBox(height: 56));

/// A [ViewInsetsPadding] body over a plain bottom bar the keyboard covers.
Widget _barPage({required bool resize, bool extendBody = false}) => MaterialApp(
  home: Scaffold(
    resizeToAvoidBottomInset: resize,
    extendBody: extendBody,
    body: const ViewInsetsPadding(child: _safeBottomField),
    bottomNavigationBar: _plainBar(),
  ),
);

Widget _composerBar() => const ViewInsetsPadding(
  key: _bar,
  child: SafeArea(top: false, child: SizedBox(height: 56)),
);

/// Bottom of the last list item, scrolled to the end, in an `extendBody` page.
Future<double> _lastItemBottom(
  WidgetTester tester,
  Widget Function(Widget child) wrap,
  Widget bar, {
  bool resize = false,
}) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: resize,
        extendBody: true,
        body: wrap(
          ListView(
            controller: controller,
            children: [
              for (var i = 0; i < 20; i++)
                SizedBox(key: ValueKey(i), height: 100),
            ],
          ),
        ),
        bottomNavigationBar: bar,
      ),
    ),
  );
  controller.jumpTo(controller.position.maxScrollExtent);
  await tester.pump();
  return tester.getBottomLeft(find.byKey(const ValueKey(19))).dy;
}

Future<Rect> _dialogFieldRect(
  WidgetTester tester,
  Widget Function(Widget child) wrap,
) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(const MaterialApp(home: Scaffold()));
  showDialog<void>(
    context: tester.element(find.byType(Scaffold)),
    builder: (_) =>
        Dialog(child: wrap(const SizedBox(key: _field, height: 50))),
  );
  await tester.pumpAndSettle();
  return tester.getRect(find.byKey(_field));
}

const _sentinel = SystemUiOverlayStyle(statusBarColor: Color(0xFF123456));

// MaterialApp sends its theme's SDK preset when it builds, so a screen whose
// regions miss the status bar shows it.
const SystemUiOverlayStyle _materialAppFallback = SystemUiOverlayStyle.dark;

/// The style sent last once [app] paints; [_sentinel] if nothing sent one.
Future<SystemUiOverlayStyle?> _styleOf(WidgetTester tester, Widget app) async {
  SystemChrome.setSystemUIOverlayStyle(_sentinel);
  await tester.pumpWidget(app);
  return SystemChrome.latestStyle;
}

const _headerChild = Key('header child');

Widget _header(Color color) => StatusBarHeader(
  color: color,
  child: const SizedBox(key: _headerChild, height: 56),
);

Widget _headerPage(Color color) => MaterialApp(
  home: Scaffold(
    body: Column(
      children: [
        _header(color),
        const Expanded(child: SizedBox.expand()),
      ],
    ),
  ),
);

const _bothPlatforms = TargetPlatformVariant({
  TargetPlatform.android,
  TargetPlatform.iOS,
});

void main() {
  group('ViewInsetsPadding', () {
    for (final keyboard in _keyboards) {
      group('at keyboard $keyboard', () {
        testWidgets('lifts modal sheet content above keyboard', (tester) async {
          _view(tester, keyboard: keyboard);
          await _showSheet(
            tester,
            (_) => const ViewInsetsPadding(
              child: SafeArea(top: false, child: _fieldBox),
            ),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        testWidgets('pads nothing in a resizing Scaffold body', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            _page(const ViewInsetsPadding(child: _safeBottomField)),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
          check(tester.getRect(find.byType(SafeArea)))
              .equals(tester.getRect(find.byType(ViewInsetsPadding)));
        });

        testWidgets('lifts a non-resizing Scaffold body', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            _page(
              const ViewInsetsPadding(child: _safeBottomField),
              resize: false,
            ),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        for (final resize in [true, false]) {
          testWidgets('lifts a bottomNavigationBar composer '
              '(resize: $resize)', (tester) async {
            _view(tester, keyboard: keyboard);
            await tester.pumpWidget(_composerPage(_withWidget, resize: resize));

            check(_fieldBottom(tester)).equals(_clear(keyboard));
          });
        }

        testWidgets('ends an extendBody list at the bar top', (tester) async {
          _view(tester, keyboard: keyboard);
          final plain = await _lastItemBottom(tester, _withWidget, _plainBar());

          check(plain).equals(keyboard > 34 ? 800 - keyboard : 710);

          final composer = await _lastItemBottom(
            tester,
            _withWidget,
            _composerBar(),
          );

          check(composer).equals(tester.getTopLeft(find.byKey(_bar)).dy);
        });

        testWidgets('ends a resizing extendBody list', (tester) async {
          _view(tester, keyboard: keyboard);
          final bottom = await _lastItemBottom(
            tester,
            _without,
            _composerBar(),
            resize: true,
          );

          check(bottom).equals(tester.getTopLeft(find.byKey(_bar)).dy);
        });

        for (final (resize, extendBody) in [(true, false), (false, true)]) {
          testWidgets('lifts a body over a bottom bar (resize: $resize, '
              'extendBody: $extendBody)', (tester) async {
            _view(tester, keyboard: keyboard);
            await tester.pumpWidget(
              _barPage(resize: resize, extendBody: extendBody),
            );

            check(_fieldBottom(tester)).equals(
              math.min(800 - keyboard, tester.getTopLeft(find.byKey(_bar)).dy),
            );
          });
        }

        testWidgets('lifts an open view with SafeArea inside', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            const MaterialApp(home: ViewInsetsPadding(child: _safeBottomField)),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        testWidgets('lands the same with SafeArea outside', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            const MaterialApp(
              home: SafeArea(
                top: false,
                child: ViewInsetsPadding(child: _bottomField),
              ),
            ),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        testWidgets('keeps inner maintainBottomViewPadding', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            const MaterialApp(
              home: ViewInsetsPadding(
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: _bottomField,
                ),
              ),
            ),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        testWidgets('pads once when nested', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(
            const MaterialApp(
              home: ViewInsetsPadding(
                child: ViewInsetsPadding(child: _safeBottomField),
              ),
            ),
          );

          check(_fieldBottom(tester)).equals(_clear(keyboard));
        });

        testWidgets('leaves a Dialog unchanged', (tester) async {
          _view(tester, keyboard: keyboard);
          final without = await _dialogFieldRect(tester, _without);
          final within = await _dialogFieldRect(tester, _withWidget);

          check(within).equals(without);
        });
      });
    }

    group('agent-style twins fail where it holds', () {
      testWidgets('bare sheet stays under the keyboard', (tester) async {
        _view(tester, keyboard: 300);
        await _showSheet(
          tester,
          (_) => const SafeArea(top: false, child: _fieldBox),
        );

        check(_fieldBottom(tester)).equals(800);
      });

      testWidgets('viewInsets + viewPadding gaps by 34', (tester) async {
        _view(tester, keyboard: 300);
        await _showSheet(
          tester,
          (context) => Padding(
            padding: .only(
              bottom:
                  MediaQuery.viewInsetsOf(context).bottom +
                  MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: _fieldBox,
          ),
        );

        check(_fieldBottom(tester)).equals(466);
      });

      testWidgets('page-context viewInsets pads twice', (tester) async {
        _view(tester, keyboard: 300);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (page) => Scaffold(
                body: Padding(
                  padding: MediaQuery.viewInsetsOf(page),
                  child: _safeBottomField,
                ),
              ),
            ),
          ),
        );

        check(_fieldBottom(tester)).equals(200);
      });

      testWidgets('bare non-resizing body stays under', (tester) async {
        _view(tester, keyboard: 300);
        await tester.pumpWidget(_page(_safeBottomField, resize: false));

        check(_fieldBottom(tester)).equals(800);
      });

      for (final (keyboard, bottom) in [(300.0, 466.0), (20.0, 746.0)]) {
        testWidgets('composer without the padding correction gaps '
            '(keyboard $keyboard)', (tester) async {
          _view(tester, keyboard: keyboard);
          await tester.pumpWidget(_composerPage(_noCorrection, resize: false));

          check(_fieldBottom(tester)).equals(bottom);
        });
      }

      testWidgets('extendBody list with a clamped correction hides behind '
          'the bar', (tester) async {
        _view(tester, keyboard: 20);

        check(await _lastItemBottom(tester, _clamp, _plainBar())).equals(780);
      });

      testWidgets('open view with a subtracting correction drops the home '
          'indicator', (tester) async {
        _view(tester, keyboard: 20);
        await tester.pumpWidget(MaterialApp(home: _subtract(_safeBottomField)));

        check(_fieldBottom(tester)).equals(780);
      });

      testWidgets('outer maintainBottomViewPadding gaps', (tester) async {
        _view(tester, keyboard: 300);
        await tester.pumpWidget(
          const MaterialApp(
            home: SafeArea(
              top: false,
              maintainBottomViewPadding: true,
              child: ViewInsetsPadding(child: _bottomField),
            ),
          ),
        );

        check(_fieldBottom(tester)).equals(466);
      });

      testWidgets('resizing Scaffold.bottomSheet pads twice', (tester) async {
        _view(tester, keyboard: 300);
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.expand(),
              bottomSheet: ViewInsetsPadding(
                child: SafeArea(top: false, child: _fieldBox),
              ),
            ),
          ),
        );

        check(_fieldBottom(tester)).equals(200);
      });
    });

    for (final (keyboard, bottom) in [(300.0, 410.0), (20.0, 690.0)]) {
      testWidgets('non-resizing body over a bottom bar pads the bar twice '
          '(keyboard $keyboard)', (tester) async {
        _view(tester, keyboard: keyboard);
        await tester.pumpWidget(_barPage(resize: false));

        check(_fieldBottom(tester)).equals(bottom);
      });
    }

    testWidgets('keeps the padding an ancestor removed without a '
        'keyboard', (tester) async {
      _view(tester);
      await tester.pumpWidget(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(padding: const .only(top: 15)),
            child: const ViewInsetsPadding(
              child: SafeArea(child: SizedBox.expand(key: _field)),
            ),
          ),
        ),
      );

      check(tester.getRect(find.byKey(_field)))
          .equals(const Rect.fromLTRB(0, 15, 400, 800));
    });

    testWidgets('throws StateError without a MediaQuery', (tester) async {
      await tester.pumpWidget(
        wrapWithView: false,
        RawView(
          view: tester.view,
          child: const ViewInsetsPadding(child: SizedBox()),
        ),
      );

      check(tester.takeException())
          .isA<StateError>()
          .has('message', (e) => e.message)
          .equals('ViewInsetsPadding needs a MediaQuery ancestor');
    });
  });

  group('StatusBarIcons', () {
    test('sets both status-bar fields and no nav-bar field', () {
      check(StatusBarIcons.light).equals(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0x00000000),
          statusBarIconBrightness: .light,
          statusBarBrightness: .dark,
        ),
      );
      check(StatusBarIcons.dark).equals(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0x00000000),
          statusBarIconBrightness: .dark,
          statusBarBrightness: .light,
        ),
      );
    });

    testWidgets('equals what a Material 3 AppBar derives', (tester) async {
      _view(tester);
      final overBlack = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(appBar: AppBar(backgroundColor: Colors.black)),
        ),
      );
      final overWhite = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(appBar: AppBar(backgroundColor: Colors.white)),
        ),
      );

      check(overBlack).equals(StatusBarIcons.light);
      check(overWhite).equals(StatusBarIcons.dark);
    }, variant: _bothPlatforms);

    testWidgets('leaves the navigation bar alone in an AppBar', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(systemOverlayStyle: StatusBarIcons.dark),
          ),
        ),
      );

      check(style).isNotNull()
        ..has('icons', (s) => s.statusBarIconBrightness).equals(.dark)
        ..has('nav color', (s) => s.systemNavigationBarColor).isNull
        ..has('nav icons', (s) => s.systemNavigationBarIconBrightness).isNull;
    }, variant: _bothPlatforms);

    testWidgets('SDK preset paints the nav bar black', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.dark),
          ),
        ),
      );

      check(style).isNotNull()
        ..has(
          'nav color',
          (s) => s.systemNavigationBarColor,
        ).equals(const Color(0xFF000000))
        ..has(
          'nav icons',
          (s) => s.systemNavigationBarIconBrightness,
        ).equals(.light);
    }, variant: TargetPlatformVariant.only(.android));

    testWidgets('hero region wins until it scrolls away', (tester) async {
      _view(tester);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: AnnotatedRegion(
            value: StatusBarIcons.dark,
            child: Scaffold(
              body: CustomScrollView(
                controller: controller,
                slivers: [
                  const SliverToBoxAdapter(
                    child: AnnotatedRegion(
                      value: StatusBarIcons.light,
                      child: ColoredBox(
                        color: Colors.black,
                        child: SizedBox(height: 300),
                      ),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      for (var i = 0; i < 20; i++) const SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      check(style).equals(StatusBarIcons.light);

      controller.jumpTo(400);
      await tester.pump();

      check(SystemChrome.latestStyle).equals(StatusBarIcons.dark);
    }, variant: _bothPlatforms);
  });

  group('StatusBarHeader', () {
    testWidgets('paints behind the status bar', (tester) async {
      _view(tester);
      final style = await _styleOf(tester, _headerPage(Colors.indigo));

      check(tester.getRect(find.byType(StatusBarHeader)))
          .equals(const Rect.fromLTWH(0, 0, 400, 103));
      check(tester.getTopLeft(find.byKey(_headerChild)).dy).equals(47);
      check(style).equals(StatusBarIcons.light);
    }, variant: _bothPlatforms);

    testWidgets('agent-style SafeArea around the region misses the status '
        'bar', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SafeArea(
                  child: AnnotatedRegion(
                    value: StatusBarIcons.light,
                    child: ColoredBox(
                      key: _bar,
                      color: Colors.indigo,
                      child: SizedBox(height: 56, width: 400),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      check(tester.getTopLeft(find.byKey(_bar)).dy).equals(47);
      check(style).equals(_materialAppFallback);
    });

    testWidgets('sets dark icons over white', (tester) async {
      _view(tester);

      check(await _styleOf(tester, _headerPage(Colors.white)))
          .equals(StatusBarIcons.dark);
    });

    testWidgets('takes icon brightness from contrastText, not the AppBar '
        'estimate', (tester) async {
      _view(tester);
      final header = await _styleOf(tester, _headerPage(Colors.blue));
      final appBar = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(appBar: AppBar(backgroundColor: Colors.blue)),
        ),
      );

      check(header).equals(StatusBarIcons.dark);
      check(appBar).equals(StatusBarIcons.light);
    });

    testWidgets('works as the first sliver', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(Colors.indigo)),
                const SliverFillRemaining(),
              ],
            ),
          ),
        ),
      );

      check(tester.getTopLeft(find.byKey(_headerChild)).dy).equals(47);
      check(style).equals(StatusBarIcons.light);
    });

    testWidgets('pads a side cutout, color full width', (tester) async {
      _view(tester, left: 44);
      await tester.pumpWidget(_headerPage(Colors.indigo));

      check(tester.getTopLeft(find.byKey(_headerChild)))
          .equals(const Offset(44, 47));
      check(
        tester.getRect(
          find.descendant(
            of: find.byType(StatusBarHeader),
            matching: find.byType(ColoredBox),
          ),
        ),
      ).equals(const Rect.fromLTWH(0, 0, 400, 103));
    });

    testWidgets('replaces the previous screen icons', (tester) async {
      _view(tester);
      await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(appBar: AppBar(backgroundColor: Colors.white)),
        ),
      );

      check(SystemChrome.latestStyle).equals(StatusBarIcons.dark);

      Navigator.of(tester.element(find.byType(AppBar))).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              Scaffold(body: Column(children: [_header(Colors.indigo)])),
        ),
      );
      await tester.pumpAndSettle();

      check(SystemChrome.latestStyle).equals(StatusBarIcons.light);
    });

    testWidgets('fills the width around a narrow child', (tester) async {
      _view(tester);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBarHeader(
                  color: Colors.indigo,
                  child: SizedBox(key: _headerChild, width: 100, height: 56),
                ),
              ],
            ),
          ),
        ),
      );

      check(tester.getRect(find.byType(StatusBarHeader)))
          .equals(const Rect.fromLTWH(0, 0, 400, 103));
    });

    testWidgets('answers intrinsic height queries', (tester) async {
      _view(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IntrinsicHeight(child: _header(Colors.indigo))),
        ),
      );

      check(tester.takeException()).isNull;
      check(tester.getSize(find.byType(StatusBarHeader)))
          .equals(const Size(400, 103));
    });

    testWidgets('unbounded width reports a FlutterError', (tester) async {
      _view(tester);
      await tester.pumpWidget(_headerPage(Colors.indigo));
      final header = tester.renderObject<RenderBox>(
        find.byType(StatusBarHeader),
      );

      // Dry layout throws it without the cascade a real layout pass produces.
      check(() => header.getDryLayout(const BoxConstraints()))
          .throws<FlutterError>();
    });

    testWidgets('sets no icons below the status bar', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [const SizedBox(height: 200), _header(Colors.indigo)],
            ),
          ),
        ),
      );

      check(style).equals(_materialAppFallback);
    });

    testWidgets('keeps its icons around an AppBar Scaffold', (tester) async {
      _view(tester);
      final style = await _styleOf(
        tester,
        MaterialApp(
          home: StatusBarHeader(
            color: Colors.black,
            child: Scaffold(appBar: AppBar(backgroundColor: Colors.white)),
          ),
        ),
      );

      check(tester.getTopLeft(find.byType(AppBar)).dy).equals(47);
      check(style).equals(StatusBarIcons.light);
    });

    group('throws StateError when the status bar inset is consumed', () {
      testWidgets('by SafeArea', (tester) async {
        _view(tester);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SafeArea(child: _header(Colors.indigo))),
          ),
        );

        check(tester.takeException()).isA<StateError>();
      });

      testWidgets('by an AppBar', (tester) async {
        _view(tester);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(appBar: AppBar(), body: _header(Colors.indigo)),
          ),
        );

        check(tester.takeException()).isA<StateError>();
      });

      testWidgets('by a ListView', (tester) async {
        _view(tester);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ListView(children: [_header(Colors.indigo)])),
          ),
        );

        check(tester.takeException()).isA<StateError>();
      });

      testWidgets('by a modal sheet route', (tester) async {
        _view(tester);
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        showModalBottomSheet<void>(
          context: tester.element(find.byType(Scaffold)),
          isScrollControlled: true,
          builder: (_) => _header(Colors.indigo),
        );
        await tester.pump();

        check(tester.takeException()).isA<StateError>();
      });
    });

    testWidgets('throws StateError without a MediaQuery', (tester) async {
      await tester.pumpWidget(
        wrapWithView: false,
        RawView(view: tester.view, child: _header(Colors.indigo)),
      );

      check(tester.takeException())
          .isA<StateError>()
          .has('message', (e) => e.message)
          .equals('StatusBarHeader needs a MediaQuery ancestor');
    });

    test('reports its color in diagnostics', () {
      final properties = const StatusBarHeader(
        color: Colors.indigo,
        child: SizedBox(),
      ).toDiagnosticsNode().getProperties();

      check(properties.whereType<ColorProperty>()).single
        ..has('name', (p) => p.name).equals('color')
        ..has('value', (p) => p.value).equals(Colors.indigo);
    });

    testWidgets('does not throw with the status bar hidden', (tester) async {
      _view(tester, top: 0);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SafeArea(child: _header(Colors.indigo))),
        ),
      );

      check(tester.takeException()).isNull;
    });

    for (final (name, color) in [
      ('translucent', const Color(0x803F51B5)),
      (
        'out-of-gamut',
        const Color.from(
          alpha: 1,
          red: 1.2,
          green: .2,
          blue: .2,
          colorSpace: .extendedSRGB,
        ),
      ),
    ]) {
      testWidgets('throws ArgumentError for a $name color', (tester) async {
        _view(tester);
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: _header(color))),
        );

        check(tester.takeException())
            .isA<ArgumentError>()
            .has('name', (e) => e.name)
            .equals('color');
      });
    }
  });
}
