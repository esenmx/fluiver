import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LocaleListener reports every locale change', (tester) async {
    final received = <List<Locale>?>[];
    final listener = LocaleListener(received.add);
    WidgetsBinding.instance.addObserver(listener);
    final dispatcher = tester.platformDispatcher;
    addTearDown(() {
      WidgetsBinding.instance.removeObserver(listener);
      dispatcher.clearLocalesTestValue();
    });

    const first = [Locale('en', 'AU')];
    const second = [Locale('en', 'AU'), Locale('tr', 'TR')];
    dispatcher
      ..localesTestValue = first
      ..localesTestValue = second;

    check(received).deepEquals([first, second]);
  });

  testWidgets('BrightnessListener reports every brightness change', (
    tester,
  ) async {
    final received = <Brightness>[];
    final listener = BrightnessListener(received.add);
    WidgetsBinding.instance.addObserver(listener);
    final dispatcher = tester.platformDispatcher;
    addTearDown(() {
      WidgetsBinding.instance.removeObserver(listener);
      dispatcher.clearPlatformBrightnessTestValue();
    });

    dispatcher
      ..platformBrightnessTestValue = .dark
      ..platformBrightnessTestValue = .light;

    check(received).deepEquals([Brightness.dark, Brightness.light]);
  });
}
