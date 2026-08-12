import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('platformDispatch', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('dispatches to matching platform callback', () {
      debugDefaultTargetPlatformOverride = .android;
      final value = platformDispatch<String>(
        android: () => 'android',
        ios: () => 'ios',
      );
      check(value).equals('android');
    }, skip: kIsWeb);

    test('throws UnsupportedError when no callback for platform', () {
      debugDefaultTargetPlatformOverride = .linux;
      String dispatch() => platformDispatch<String>(android: () => 'android');
      check(dispatch).throws<UnsupportedError>();
    }, skip: kIsWeb);

    test('all platforms route to their slot', () {
      for (final platform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = platform;
        final value = platformDispatch<TargetPlatform>(
          android: () => .android,
          fuchsia: () => .fuchsia,
          ios: () => .iOS,
          linux: () => .linux,
          macos: () => .macOS,
          windows: () => .windows,
        );
        check(value).equals(platform);
      }
    }, skip: kIsWeb);

    test('dispatches to web callback on web platform', () {
      final value = platformDispatch<String>(
        android: () => 'android',
        web: () => 'web',
      );
      check(value).equals('web');
    }, skip: !kIsWeb);

    test('throws UnsupportedError when no web callback on web platform', () {
      String dispatch() => platformDispatch<String>(android: () => 'android');
      check(dispatch).throws<UnsupportedError>();
    }, skip: !kIsWeb);
  });
}
