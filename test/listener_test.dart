import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listener_test.mocks.dart';

class MockBrightnessListenerCallback extends Mock {
  void call(Brightness brightness);
}

@GenerateMocks([LocaleListener])
void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  testWidgets('LocaleListener', (tester) async {
    final observer = MockLocaleListener();
    WidgetsBinding.instance.addObserver(observer);
    final window = tester.binding.platformDispatcher;

    final value1 = [const Locale('en_AU')];
    window.localesTestValue = value1;
    verify(observer.didChangeLocales(value1)).called(1);

    final value2 = [const Locale('en_AU'), const Locale('tr_TR')];
    window.localesTestValue = value2;
    verify(observer.didChangeLocales(value2)).called(1);
  });

  testWidgets('BrightnessListener', (tester) async {
    final callback = MockBrightnessListenerCallback();
    WidgetsBinding.instance.addObserver(BrightnessListener(callback.call));
    final window = tester.binding.platformDispatcher
      ..platformBrightnessTestValue = .dark;
    verify(callback(.dark)).called(1);

    window.platformBrightnessTestValue = .light;
    verify(callback(.light)).called(1);

    window.platformBrightnessTestValue = .light;
    verify(callback(.light)).called(1);
  });
}
