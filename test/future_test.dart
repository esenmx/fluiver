import 'dart:async';

import 'package:checks/checks.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('timeoutOrNull', () {
    test('returns value when future completes within timeout', () {
      fakeAsync((async) {
        int? captured;
        unawaited(
          Future.delayed(const Duration(milliseconds: 50), () => 42)
              .timeoutOrNull(const Duration(milliseconds: 100))
              .then((v) => captured = v),
        );

        async.elapse(const Duration(milliseconds: 60));

        check(captured).equals(42);
      });
    });

    test('returns null when timeout elapses first', () {
      fakeAsync((async) {
        int? captured = -1;
        unawaited(
          Future.delayed(const Duration(seconds: 5), () => 42)
              .timeoutOrNull(const Duration(milliseconds: 100))
              .then((v) => captured = v),
        );

        async.elapse(const Duration(milliseconds: 150));

        check(captured).isNull();
      });
    });

    test('propagates errors from the underlying future', () async {
      const error = FormatException('bad');
      const timeout = Duration(seconds: 1);
      final f = Future<int>.error(error).timeoutOrNull(timeout);

      await check(f).throws<FormatException>();
    });
  });
}
