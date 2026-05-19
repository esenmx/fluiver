import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('platformDispatch', () {
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('dispatches to matching platform callback', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final value = platformDispatch<String>(
        android: () => 'android',
        ios: () => 'ios',
      );
      check(value).equals('android');
    });

    test('throws UnsupportedError when no callback for platform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      check(
        () => platformDispatch<String>(android: () => 'android'),
      ).throws<UnsupportedError>();
    });

    test('all platforms route to their slot', () {
      for (final platform in [
        TargetPlatform.android,
        TargetPlatform.fuchsia,
        TargetPlatform.iOS,
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        final value = platformDispatch<TargetPlatform>(
          android: () => TargetPlatform.android,
          fuchsia: () => TargetPlatform.fuchsia,
          ios: () => TargetPlatform.iOS,
          linux: () => TargetPlatform.linux,
          macOS: () => TargetPlatform.macOS,
          windows: () => TargetPlatform.windows,
        );
        check(value).equals(platform);
      }
    });
  });
}
