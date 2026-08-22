import 'dart:async';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisposableBag', () {
    test('runs disposers in registration order', () async {
      final calls = <String>[];
      final bag = DisposableBag()
        ..add(() => calls.add('a'))
        ..add(() => calls.add('b'))
        ..add(() => calls.add('c'));

      await bag.dispose();
      check(calls).deepEquals(['a', 'b', 'c']);
    });

    test('dispose is idempotent', () async {
      var calls = 0;
      final bag = DisposableBag()..add(() => calls++);

      await bag.dispose();
      await bag.dispose();
      check(calls).equals(1);
      check(bag.isDisposed).isTrue();
    });

    test('add after dispose runs disposer immediately', () async {
      final calls = <String>[];
      final bag = DisposableBag();
      await bag.dispose();
      bag.add(() => calls.add('late'));
      // Allow the queued microtask to flush.
      await Future<void>.delayed(.zero);
      check(calls).deepEquals(['late']);
      check(bag.length).equals(0);
    });

    test('add after dispose propagates error if disposer throws', () async {
      final bag = DisposableBag();
      await bag.dispose();

      Object? caughtError;
      runZonedGuarded(
        () {
          bag.add(() => throw Exception('late error'));
        },
        (error, _) {
          caughtError = error;
        },
      );

      // Allow the queued microtask to flush.
      await Future<void>.delayed(.zero);

      check(caughtError)
        ..isNotNull()
        ..isA<Exception>()
            .has((e) => e.toString(), 'toString')
            .contains('late error');
    });

    test('length tracks pending disposers', () async {
      final bag = DisposableBag()
        ..add(() {})
        ..add(() {});
      check(bag.length).equals(2);
      await bag.dispose();
      check(bag.length).equals(0);
    });

    test('awaits async disposers', () async {
      var done = false;
      final bag = DisposableBag()
        ..add(() async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          done = true;
        });
      await bag.dispose();
      check(done).isTrue();
    });

    test('addAll registers each closure in order', () async {
      final calls = <String>[];
      final bag = DisposableBag()
        ..addAll([
          () => calls.add('a'),
          () => calls.add('b'),
          () => calls.add('c'),
        ]);

      check(bag.length).equals(3);
      await bag.dispose();
      check(calls).deepEquals(['a', 'b', 'c']);
    });

    test('runs subsequent disposers even if one throws, '
        'throwing DisposableBagException at the end', () async {
      final calls = <String>[];
      final bag = DisposableBag()
        ..add(() => calls.add('a'))
        ..add(() => throw Exception('faulty disposer'))
        ..add(() => calls.add('c'));

      await check(bag.dispose()).throws<DisposableBagException>();
      check(calls).deepEquals(['a', 'c']);
    });

    test('executes async disposers concurrently', () async {
      final order = <String>[];
      final bag = DisposableBag()
        ..add(() async {
          order.add('start-a');
          await Future<void>.delayed(const Duration(milliseconds: 20));
          order.add('end-a');
        })
        ..add(() async {
          order.add('start-b');
          await Future<void>.delayed(const Duration(milliseconds: 10));
          order.add('end-b');
        });

      await bag.dispose();
      // Both disposers start synchronously before either completes.
      // b takes 10ms, a takes 20ms, so b finishes before a.
      check(order).deepEquals(['start-a', 'start-b', 'end-b', 'end-a']);
    });

    test('collects errors from async disposers', () async {
      final bag = DisposableBag()
        ..add(() async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          throw Exception('async error 1');
        })
        ..add(() async {
          await Future<void>.delayed(const Duration(milliseconds: 5));
          throw Exception('async error 2');
        });

      DisposableBagException? exception;
      try {
        await bag.dispose();
      } on DisposableBagException catch (e) {
        exception = e;
      }

      check(exception).isNotNull();
      check(exception!.errors.length).equals(2);
    });
  });
}
