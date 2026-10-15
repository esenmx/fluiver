import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LocaleListener registers itself and reports every change', (
    tester,
  ) async {
    final received = <List<Locale>?>[];
    final listener = LocaleListener(received.add);
    final dispatcher = tester.platformDispatcher;
    addTearDown(() {
      listener.dispose();
      dispatcher.clearLocalesTestValue();
    });

    const first = [Locale('en', 'AU')];
    const second = [Locale('en', 'AU'), Locale('tr', 'TR')];
    dispatcher
      ..localesTestValue = first
      ..localesTestValue = second;

    check(received).deepEquals([first, second]);
  });

  testWidgets('BrightnessListener registers itself and reports every change', (
    tester,
  ) async {
    final received = <Brightness>[];
    final listener = BrightnessListener(received.add);
    final dispatcher = tester.platformDispatcher;
    addTearDown(() {
      listener.dispose();
      dispatcher.clearPlatformBrightnessTestValue();
    });

    dispatcher
      ..platformBrightnessTestValue = .dark
      ..platformBrightnessTestValue = .light;

    check(received).deepEquals([Brightness.dark, Brightness.light]);
  });

  for (final (name, listen, change)
      in <
        (
          String,
          VoidCallback Function(VoidCallback onChange),
          void Function(TestPlatformDispatcher dispatcher),
        )
      >[
        (
          'LocaleListener',
          (onChange) => LocaleListener((_) => onChange()).dispose,
          (dispatcher) {
            addTearDown(dispatcher.clearLocalesTestValue);
            dispatcher.localesTestValue = const [Locale('tr', 'TR')];
          },
        ),
        (
          'BrightnessListener',
          (onChange) => BrightnessListener((_) => onChange()).dispose,
          (dispatcher) {
            addTearDown(dispatcher.clearPlatformBrightnessTestValue);
            dispatcher.platformBrightnessTestValue = .dark;
          },
        ),
      ]) {
    group(name, () {
      testWidgets('stops reporting after dispose', (tester) async {
        var calls = 0;
        final dispose = listen(() => calls++);
        dispose();

        change(tester.platformDispatcher);

        check(calls).equals(0);
      });

      testWidgets('is not called once disposed during the same delivery', (
        tester,
      ) async {
        VoidCallback? disposeSecond;
        final disposeFirst = listen(() {
          disposeSecond?.call();
          disposeSecond = null;
        });
        addTearDown(disposeFirst);
        var calls = 0;
        disposeSecond = listen(() => calls++);

        change(tester.platformDispatcher);

        check(calls).equals(0);
      });

      testWidgets('throws StateError when disposed twice', (tester) async {
        final dispose = listen(() {});
        dispose();

        check(dispose).throws<StateError>();
      });
    });
  }
}
