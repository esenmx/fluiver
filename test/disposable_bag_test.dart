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

    test(
      'add after dispose throws StateError and never runs the disposer',
      () async {
        final calls = <String>[];
        final bag = DisposableBag();
        await bag.dispose();

        check(() => bag.add(() => calls.add('late'))).throws<StateError>();
        check(() => bag.addAll([() => calls.add('late')])).throws<StateError>();
        await Future<void>.delayed(.zero);
        check(calls).isEmpty();
        check(bag.length).equals(0);
      },
    );

    test('dispose called from its own disposer throws StateError', () async {
      var calls = 0;
      late final DisposableBag bag;
      bag = DisposableBag()
        ..add(() => bag.dispose())
        ..add(() async {
          await null;
          bag.add(() => calls++);
        });

      await check(bag.dispose()).throws<DisposableBagException>(
        (it) => it.has((e) => e.errors, 'errors')
          ..length.equals(1)
          ..first.isA<StateError>(),
      );
      check(calls).equals(1);
    });

    test('a disposer awaiting its own bag fails instead of hanging', () async {
      late final DisposableBag bag;
      bag = DisposableBag()..add(() async => await bag.dispose());

      await check(bag.dispose().timeout(const Duration(seconds: 1)))
          .throws<DisposableBagException>(
            (it) => it.has((e) => e.errors.single, 'error').isA<StateError>(),
          );
    });

    test('a cycle between two bags fails instead of hanging', () async {
      final a = DisposableBag();
      final b = DisposableBag();
      a.add(() async => await b.dispose());
      b.add(() async => await a.dispose());

      await check(a.dispose().timeout(const Duration(seconds: 1)))
          .throws<DisposableBagException>(
            (it) => it
                .has((e) => e.errors.single, 'error')
                .isA<DisposableBagException>(),
          );
    });

    test(
      'a second dispose during an in-flight dispose settles with it',
      () async {
        final gate = Completer<void>();
        var released = false;
        final bag = DisposableBag()
          ..add(() async {
            await gate.future;
            released = true;
          });

        final first = bag.dispose();
        var secondSettled = false;
        final second = bag.dispose().then((_) => secondSettled = true);
        await Future<void>.delayed(.zero);
        check(
          because: 'the slow disposer has not finished',
          secondSettled,
        ).isFalse();

        gate.complete();
        await Future.wait([first, second]);
        check(released).isTrue();
        check(secondSettled).isTrue();
      },
    );

    test(
      'a second dispose during an in-flight dispose surfaces its errors',
      () async {
        final gate = Completer<void>();
        final bag = DisposableBag()
          ..add(() async {
            await gate.future;
            throw StateError('boom');
          });

        final first = bag.dispose();
        final second = bag.dispose();
        gate.complete();
        await check(first).throws<DisposableBagException>();
        await check(second).throws<DisposableBagException>();
      },
    );

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

    test('starts async disposers in order without awaiting each', () async {
      final order = <String>[];
      final a = Completer<void>();
      final b = Completer<void>();
      final bag = DisposableBag()
        ..add(() async {
          order.add('start-a');
          await a.future;
          order.add('end-a');
        })
        ..add(() async {
          order.add('start-b');
          await b.future;
          order.add('end-b');
        });
      final done = bag.dispose();
      check(order).deepEquals(['start-a', 'start-b']);
      b.complete();
      a.complete();
      await done;
      check(order).deepEquals(['start-a', 'start-b', 'end-b', 'end-a']);
    });

    test('collects every async disposer error', () async {
      final bag = DisposableBag()
        ..add(() async => throw Exception('async error 1'))
        ..add(() async => throw Exception('async error 2'));
      await check(bag.dispose()).throws<DisposableBagException>(
        (e) => e.has((e) => e.errors, 'errors').length.equals(2),
      );
    });

    test('captures a stack trace per error, index-aligned', () async {
      void throwingSyncDisposer() => throw Exception('sync');
      Future<void> throwingAsyncDisposer() async => throw Exception('async');
      final bag = DisposableBag()
        ..add(throwingSyncDisposer)
        ..add(throwingAsyncDisposer);
      await check(bag.dispose()).throws<DisposableBagException>(
        (e) => e
          ..has((e) => e.errors.length, 'errors.length').equals(2)
          ..has((e) => e.stackTraces.length, 'stackTraces.length').equals(2)
          ..has(
            (e) => '${e.stackTraces[0]}',
            'stackTraces[0]',
          ).contains('throwingSyncDisposer')
          ..has(
            (e) => '${e.stackTraces[1]}',
            'stackTraces[1]',
          ).contains('throwingAsyncDisposer'),
      );
    });

    test('collects sync and async errors in registration order', () async {
      final a = Completer<void>();
      final b = Completer<void>();
      final bag = DisposableBag()
        ..add(() async {
          await a.future;
          throw Exception('first');
        })
        ..add(() async {
          await b.future;
          throw Exception('second');
        })
        ..add(() => throw Exception('third'));
      final done = bag.dispose();
      b.complete();
      a.complete();
      await check(done).throws<DisposableBagException>(
        (e) => e
            .has((e) => e.errors.map((o) => o.toString()).toList(), 'errors')
            .deepEquals([
              'Exception: first',
              'Exception: second',
              'Exception: third',
            ]),
      );
    });

    test('runs inline, awaits, and collects errors from disposers added '
        're-entrantly during dispose', () async {
      final calls = <String>[];
      final bag = DisposableBag();
      bag
        ..add(() {
          calls.add('outer');
          bag
            ..add(() => calls.add('late'))
            ..add(() async {
              await Future<void>.delayed(const Duration(milliseconds: 5));
              calls.add('reentrant');
              throw Exception('reentrant failure');
            });
        })
        ..add(() => calls.add('second'));

      await check(bag.dispose()).throws<DisposableBagException>(
        (e) => e
            .has((e) => e.errors.map((o) => o.toString()).toList(), 'errors')
            .deepEquals(['Exception: reentrant failure']),
      );
      check(calls).deepEquals(['outer', 'late', 'second', 'reentrant']);
      check(bag.isDisposed).isTrue();
      check(bag.length).equals(0);
    });
  });

  group('DisposableBagException', () {
    test('toString formats single error correctly', () {
      final exception = DisposableBagException([Exception('error 1')]);

      check(exception.toString()).equals(
        'DisposableBagException: 1 disposer(s) threw errors:\n'
        ' - Exception: error 1',
      );
    });

    test('toString formats multiple errors correctly', () {
      final exception = DisposableBagException([
        Exception('first error'),
        'second error',
      ]);

      check(exception.toString()).equals(
        'DisposableBagException: 2 disposer(s) threw errors:\n'
        ' - Exception: first error\n'
        ' - second error',
      );
    });

    test('errors and stackTraces lists are unmodifiable', () {
      final exception = DisposableBagException(
        [Exception('e')],
        stackTraces: [.current],
      );

      check(() => exception.errors.add('x')).throws<UnsupportedError>();
      check(() => exception.stackTraces.add(.current))
          .throws<UnsupportedError>();
    });
  });
}
