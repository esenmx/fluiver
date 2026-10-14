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
          ..has((e) => e.name, 'name').equals('duration')
          ..has((e) => e.message, 'message').equals('must not be negative');
      });

      test('$name accepts Duration.zero', () {
        check(create(Duration.zero)).isNotNull();
      });
    }
  });

  group('Reactive Helpers', () {
    reactiveTest('Debounce executes task after duration', (async, log) {
      final debounce = Debounce(const Duration(milliseconds: 100));

      debounce(() => log.add('task1'));

      async.elapse(const Duration(milliseconds: 50));
      check(log).isEmpty();

      debounce(() => log.add('task2'));

      async.elapse(const Duration(milliseconds: 99));
      check(log).isEmpty();

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
      check(log).isEmpty();

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
      check(log).isEmpty();
    });

    reactiveTest('dispose drops the pending ThrottleLast task', (async, log) {
      final throttle = ThrottleLast(const Duration(milliseconds: 100));

      throttle(() => log.add('task'));
      throttle.dispose();

      async.elapse(const Duration(milliseconds: 200));
      check(log).isEmpty();
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
      check(log).isEmpty();
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
      check(async.pendingTimers, because: 'dispose leaves a timer').isEmpty();
    });

    test('ThrottleLatest dispose cancels every timer it armed', () {
      fakeAsync((async) {
        final t = ThrottleLatest(window)..call(() {});
        t(() => t(() {}));
        async.elapse(window);
        t.dispose();
        check(async.pendingTimers).isEmpty();
      });
    });
  });
}
