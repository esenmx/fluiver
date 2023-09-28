import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'observer_test.mocks.dart';

class MockBrightnessObserverCallback extends Mock {
  void call(Brightness brightness);
}

@GenerateMocks([LocaleObserver])
void main() async {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  testWidgets('LocaleObserver', (tester) async {
    final observer = MockLocaleObserver();
    WidgetsBinding.instance.addObserver(observer);
    final window = tester.binding.platformDispatcher;

    final value1 = [const Locale('en_AU')];
    window.localesTestValue = value1;
    verify(observer.didChangeLocales(value1)).called(1);

    final value2 = [const Locale('en_AU'), const Locale('tr_TR')];
    window.localesTestValue = value2;
    verify(observer.didChangeLocales(value2)).called(1);
  });

  testWidgets('BrightnessObserver', (tester) async {
    final callback = MockBrightnessObserverCallback();
    WidgetsBinding.instance.addObserver(BrightnessObserver(callback.call));
    final window = tester.binding.platformDispatcher;

    window.platformBrightnessTestValue = Brightness.dark;
    verify(callback(Brightness.dark)).called(1);

    window.platformBrightnessTestValue = Brightness.light;
    verify(callback(Brightness.light)).called(1);

    window.platformBrightnessTestValue = Brightness.light;
    verify(callback(Brightness.light)).called(1);
  });
}
