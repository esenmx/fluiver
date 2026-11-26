import 'dart:async';

import 'package:checks/checks.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTest
void reactiveTest(
  String description,
  void Function(FakeAsync async, List<String> log) body, {
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  test(
    description,
    () => fakeAsync((async) => body(async, <String>[])),
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

void main() {
  group('negative duration', () {
    const negative = Duration(milliseconds: -1);
    for (final (name, create) in <(String, Object Function(Duration))>[
      ('Debounce', Debounce.new),
      ('ThrottleLatest', ThrottleLatest.new),
      ('ThrottleFirst', ThrottleFirst.new),
      ('ThrottleLast', ThrottleLast.new),
    ]) {
      test('$name throws ArgumentError naming duration', () {
        check(() => create(negative)).throws<ArgumentError>()
          ..has('name', (e) => e.name).equals('duration')
          ..has('message', (e) => e.message).equals('must not be negative');
      });

      test('$name accepts Duration.zero', () {
        check(create(.zero)).isNotNull();
      });
    }
  });

  group('Reactive Helpers', () {
    reactiveTest('Debounce executes task after duration', (async, log) {
      final debounce = Debounce(const Duration(milliseconds: 100));

      debounce(() => log.add('task1'));

      async.elapse(const Duration(milliseconds: 50));
      check(log).isEmpty;

      debounce(() => log.add('task2'));

      async.elapse(const Duration(milliseconds: 99));
      check(log).isEmpty;

      async.elapse(const Duration(milliseconds: 2));
      check(log).deepEquals(['task2']);

      debounce.dispose();
    });

    reactiveTest('ThrottleLatest executes immediately then queues latest', (
      async,
      log,
    ) {
      final throttle = ThrottleLatest(const Duration(milliseconds: 100));

      throttle(() => log.add('task1'));
      check(log).deepEquals(['task1']);

      async.elapse(const Duration(milliseconds: 10));

      throttle(() => log.add('task2'));
      throttle(() => log.add('task3'));

      check(log).deepEquals(['task1']);

      async.elapse(const Duration(milliseconds: 90));

      check(log).deepEquals(['task1', 'task3']);

      throttle.dispose();
    });

    reactiveTest('ThrottleFirst executes immediately then ignores others', (
      async,
      log,
    ) {
      final throttle = ThrottleFirst(const Duration(milliseconds: 100));

      throttle(() => log.add('task1'));
      check(log).deepEquals(['task1']);

      async.elapse(const Duration(milliseconds: 10));

      throttle(() => log.add('task2'));
      throttle(() => log.add('task3'));

      async.elapse(const Duration(milliseconds: 90));
      check(log).deepEquals(['task1']);

      throttle(() => log.add('task4'));
      check(log).deepEquals(['task1', 'task4']);

      throttle.dispose();
    });

    reactiveTest('ThrottleLast waits for duration then executes latest', (
      async,
      log,
    ) {
      final throttle = ThrottleLast(const Duration(milliseconds: 100));

      throttle(() => log.add('task1'));
      check(log).isEmpty;

      async.elapse(const Duration(milliseconds: 10));

      throttle(() => log.add('task2'));

      async.elapse(const Duration(milliseconds: 90));

      check(log).deepEquals(['task2']);

      throttle.dispose();
    });

    reactiveTest('dispose drops the pending Debounce task', (async, log) {
      final debounce = Debounce(const Duration(milliseconds: 100));

      debounce(() => log.add('task'));
      debounce.dispose();

      async.elapse(const Duration(milliseconds: 200));
      check(log).isEmpty;
    });

    reactiveTest('dispose drops the pending ThrottleLast task', (async, log) {
      final throttle = ThrottleLast(const Duration(milliseconds: 100));

      throttle(() => log.add('task'));
      throttle.dispose();

      async.elapse(const Duration(milliseconds: 200));
      check(log).isEmpty;
    });

    reactiveTest('dispose drops the queued ThrottleLatest task', (async, log) {
      final throttle = ThrottleLatest(const Duration(milliseconds: 100));

      throttle(() => log.add('first'));
      throttle(() => log.add('queued'));
      throttle.dispose();

      async.elapse(const Duration(milliseconds: 200));
      check(log).deepEquals(['first']);
    });

    reactiveTest('calling a disposed instance throws StateError', (async, log) {
      const d = Duration(milliseconds: 100);
      final debounce = Debounce(d)..dispose();
      final throttleLatest = ThrottleLatest(d)..dispose();
      final throttleFirst = ThrottleFirst(d)..dispose();
      final throttleLast = ThrottleLast(d)..dispose();

      check(() => debounce(() => log.add('task'))).throws<StateError>();
      check(() => throttleLatest(() => log.add('task'))).throws<StateError>();
      check(() => throttleFirst(() => log.add('task'))).throws<StateError>();
      check(() => throttleLast(() => log.add('task'))).throws<StateError>();
      check(log).isEmpty;
    });

    for (final (name, dispose) in <(String, void Function())>[
      ('Debounce', Debounce(const Duration(milliseconds: 1)).dispose),
      (
        'ThrottleLatest',
        ThrottleLatest(const Duration(milliseconds: 1)).dispose,
      ),
      ('ThrottleFirst', ThrottleFirst(const Duration(milliseconds: 1)).dispose),
      ('ThrottleLast', ThrottleLast(const Duration(milliseconds: 1)).dispose),
    ]) {
      test('a second $name.dispose throws StateError', () {
        dispose();
        check(dispose).throws<StateError>();
      });
    }
  });

  group('Debounce pending task', () {
    const quiet = Duration(milliseconds: 100);

    reactiveTest('isPending follows the scheduled task', (async, log) {
      final debounce = Debounce(quiet);
      check(debounce.isPending).isFalse;

      debounce(() => log.add('task'));
      check(debounce.isPending).isTrue;

      async.elapse(quiet);
      check(log).deepEquals(['task']);
      check(debounce.isPending).isFalse;

      debounce.flush();
      check(log).deepEquals(['task']);
      debounce.dispose();
    });

    reactiveTest('flush runs the pending task once, now', (async, log) {
      final debounce = Debounce(quiet)
        ..call(() => log.add('task'))
        ..flush();
      check(log).deepEquals(['task']);
      check(debounce.isPending).isFalse;
      check(async.pendingTimers).isEmpty;

      async.elapse(quiet);
      check(log).deepEquals(['task']);
      debounce.dispose();
    });

    reactiveTest('flush with nothing pending does nothing', (async, log) {
      final debounce = Debounce(quiet);

      check(debounce.flush).returnsNormally();
      debounce.dispose();
    });

    reactiveTest('cancel drops the task and keeps it usable', (async, log) {
      final debounce = Debounce(quiet)
        ..call(() => log.add('dropped'))
        ..cancel();
      check(debounce.isPending).isFalse;
      check(async.pendingTimers).isEmpty;

      async.elapse(quiet);
      check(log).isEmpty;

      debounce(() => log.add('kept'));
      async.elapse(quiet);
      check(log).deepEquals(['kept']);
      debounce.dispose();
    });

    reactiveTest('a task scheduled during flush stays pending', (async, log) {
      final debounce = Debounce(quiet);
      debounce(() {
        log.add('first');
        debounce(() => log.add('second'));
      });

      debounce.flush();
      check(log).deepEquals(['first']);
      check(debounce.isPending).isTrue;

      async.elapse(quiet);
      check(log).deepEquals(['first', 'second']);
      debounce.dispose();
    });

    reactiveTest('a throwing task leaves nothing pending', (async, log) {
      final debounce = Debounce(quiet)..call(() => throw StateError('boom'));

      check(debounce.flush).throws<StateError>();
      check(debounce.isPending).isFalse;
      check(async.pendingTimers).isEmpty;
      debounce.dispose();
    });

    reactiveTest('after dispose flush and cancel throw', (async, log) {
      final debounce = Debounce(quiet)
        ..call(() => log.add('task'))
        ..dispose();

      check(debounce.isPending).isFalse;
      check(debounce.flush).throws<StateError>();
      check(debounce.cancel).throws<StateError>();
      async.elapse(quiet);
      check(log).isEmpty;
    });
  });

  group('ThrottleLast pending task', () {
    const window = Duration(milliseconds: 100);

    reactiveTest('flush runs the waiting task once, now', (async, log) {
      final throttle = ThrottleLast(window);
      check(throttle.isPending).isFalse;

      throttle(() => log.add('task'));
      check(throttle.isPending).isTrue;

      throttle.flush();
      check(log).deepEquals(['task']);
      check(throttle.isPending).isFalse;
      check(async.pendingTimers).isEmpty;

      throttle.flush();
      async.elapse(window);
      check(log).deepEquals(['task']);
      throttle.dispose();
    });

    reactiveTest('cancel drops the task and keeps it usable', (async, log) {
      final throttle = ThrottleLast(window)
        ..call(() => log.add('dropped'))
        ..cancel();
      check(throttle.isPending).isFalse;
      async.elapse(window);
      check(log).isEmpty;

      throttle(() => log.add('kept'));
      async.elapse(window);
      check(log).deepEquals(['kept']);
      check(throttle.isPending).isFalse;
      throttle.dispose();
    });

    reactiveTest('after dispose flush and cancel throw', (async, log) {
      final throttle = ThrottleLast(window)
        ..call(() => log.add('task'))
        ..dispose();

      check(throttle.isPending).isFalse;
      check(throttle.flush).throws<StateError>();
      check(throttle.cancel).throws<StateError>();
    });
  });

  group('ThrottleLatest pending task', () {
    const window = Duration(milliseconds: 100);

    reactiveTest('flush runs the queued task in a new window', (async, log) {
      final throttle = ThrottleLatest(window)..call(() => log.add('first'));
      check(throttle.isPending).isFalse;

      async.elapse(const Duration(milliseconds: 40));
      throttle(() => log.add('queued'));
      check(throttle.isPending).isTrue;

      throttle.flush();
      check(log).deepEquals(['first', 'queued']);
      check(throttle.isPending).isFalse;

      async.elapse(const Duration(milliseconds: 90));
      throttle(() => log.add('inside the new window'));
      check(log).deepEquals(['first', 'queued']);
      async.elapse(const Duration(milliseconds: 10));
      check(log).deepEquals(['first', 'queued', 'inside the new window']);
      throttle.dispose();
    });

    reactiveTest('flush with nothing queued keeps the window', (async, log) {
      final throttle = ThrottleLatest(window)
        ..call(() => log.add('first'))
        ..flush()
        ..call(() => log.add('queued'));
      check(log).deepEquals(['first']);

      async.elapse(window);
      check(log).deepEquals(['first', 'queued']);
      throttle.dispose();
    });

    reactiveTest('cancel drops the queued task only', (async, log) {
      final throttle = ThrottleLatest(window)
        ..call(() => log.add('first'))
        ..call(() => log.add('dropped'))
        ..cancel();
      check(throttle.isPending).isFalse;

      throttle(() => log.add('queued'));
      check(log).deepEquals(['first']);
      async.elapse(window);
      check(log).deepEquals(['first', 'queued']);
      throttle.dispose();
    });

    reactiveTest('after dispose flush and cancel throw', (async, log) {
      final throttle = ThrottleLatest(window)
        ..call(() => log.add('first'))
        ..call(() => log.add('queued'))
        ..dispose();

      check(throttle.isPending).isFalse;
      check(throttle.flush).throws<StateError>();
      check(throttle.cancel).throws<StateError>();
    });
  });

  group('LatestOnly', () {
    test('delivers the result of a single call', () async {
      final latest = LatestOnly();

      check(await latest(() async => 'only')).equals('only');
      latest.dispose();
    });

    test('drops a slow older result that arrives last', () async {
      final latest = LatestOnly();
      final older = Completer<String>();
      final newer = Completer<String>();
      final first = latest(() => older.future);
      final second = latest(() => newer.future);

      newer.complete('new');
      older.complete('old');
      check(await first).isNull;
      check(await second).equals('new');
      latest.dispose();
    });

    test('drops an older result that arrives first', () async {
      final latest = LatestOnly();
      final newer = Completer<String>();
      final first = latest(() async => 'old');
      final second = latest(() => newer.future);

      check(await first).isNull;
      newer.complete('new');
      check(await second).equals('new');
      latest.dispose();
    });

    test('drops the error of a superseded call', () async {
      final latest = LatestOnly();
      final older = Completer<String>();
      final first = latest(() => older.future);
      final second = latest(() async => 'new');

      older.completeError(StateError('stale'));
      check(await first).isNull;
      check(await second).equals('new');
      latest.dispose();
    });

    test('throws the error of the newest call', () async {
      final latest = LatestOnly();

      await check(latest<String>(() async => throw StateError('boom')))
          .throws<StateError>();
      latest.dispose();
    });

    test('dispose drops the result of a running call', () async {
      final latest = LatestOnly();
      final running = Completer<String>();
      final result = latest(() => running.future);

      latest.dispose();
      running.complete('late');
      check(await result).isNull;
    });

    test('throws StateError when used after dispose', () {
      final latest = LatestOnly()..dispose();

      check(() => latest(() async => 'x')).throws<StateError>();
      check(latest.dispose).throws<StateError>();
    });
  });

  group('Throttle re-entrancy', () {
    const window = Duration(milliseconds: 100);

    test('ThrottleFirst ignores calls within the window even if task '
        'threw', () {
      fakeAsync((async) {
        final t = ThrottleFirst(window);
        var runs = 0;
        check(() {
          t(() {
            runs++;
            throw Exception('submit failed');
          });
        }).throws<Exception>();
        async.elapse(const Duration(milliseconds: 10));
        t(() => runs++);
        check(runs, because: 'second call inside the window ran').equals(1);
        t.dispose();
      });
    });

    test('ThrottleFirst reentrant call within the window is dropped', () {
      fakeAsync((async) {
        final t = ThrottleFirst(window);
        var runs = 0;
        void task() {
          runs++;
          if (runs < 5) {
            t(task);
          }
        }

        t(task);
        check(runs).equals(1);
        t.dispose();
      });
    });

    reactiveTest('ThrottleLast does not lose a call made while its task '
        'runs', (async, log) {
      final t = ThrottleLast(window);
      t(() {
        log.add('first');
        t(() => log.add('second'));
      });
      async.elapse(const Duration(milliseconds: 350));
      check(log).deepEquals(['first', 'second']);
      t.dispose();
    });

    reactiveTest('ThrottleLatest reentrant call from a queued task is '
        'rate-limited', (async, log) {
      final t = ThrottleLatest(window)..call(() => log.add('a'));
      t(() {
        log.add('b');
        t(() => log.add('c'));
      });
      async.elapse(window);
      check(
        log,
        because: 'c should wait for the next window',
      ).deepEquals(['a', 'b']);
      t.dispose();
      async.elapse(const Duration(milliseconds: 500));
      check(async.pendingTimers, because: 'dispose leaves a timer').isEmpty;
    });

    test('ThrottleLatest dispose cancels every timer it armed', () {
      fakeAsync((async) {
        final t = ThrottleLatest(window)..call(() {});
        t(() => t(() {}));
        async.elapse(window);
        t.dispose();
        check(async.pendingTimers).isEmpty;
      });
    });
  });
}
