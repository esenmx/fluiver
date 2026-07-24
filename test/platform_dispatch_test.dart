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
    });

    test('throws UnsupportedError when no callback for platform', () {
      debugDefaultTargetPlatformOverride = .linux;
      String dispatch() => platformDispatch<String>(android: () => 'android');
      check(dispatch).throws<UnsupportedError>();
    });

    test('all platforms route to their slot', () {
      for (final platform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = platform;
        final value = platformDispatch<TargetPlatform>(
          android: () => .android,
          fuchsia: () => .fuchsia,
          ios: () => .iOS,
          linux: () => .linux,
          macOS: () => .macOS,
          windows: () => .windows,
        );
        check(value).equals(platform);
      }
    });
  });
}
