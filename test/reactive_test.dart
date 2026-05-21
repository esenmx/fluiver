import 'package:checks/checks.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void reactiveTest(
  String description,
  void Function(FakeAsync async, List<String> log) body,
) {
  test(description, () {
    fakeAsync((async) => body(async, <String>[]));
  });
}

void main() {
  group('Reactive Helpers', () {
    reactiveTest('Debounce executes task after duration', (async, log) {
      final debounce = Debounce(const Duration(milliseconds: 100));

      debounce(() => log.add('task1'));

      async.elapse(const Duration(milliseconds: 50));
      check(log).isEmpty();

      // Overwrite previous task
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

      // First call: immediate execution
      throttle(() => log.add('task1'));
      check(log).deepEquals(['task1']);

      async.elapse(const Duration(milliseconds: 10));

      // Calls during cooldown are queued
      throttle(() => log.add('task2')); // overwritten by task3
      throttle(() => log.add('task3'));

      check(log).deepEquals(['task1']); // No new execution yet

      async.elapse(const Duration(milliseconds: 90));

      // After cooldown, latest pending task executes
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

      // Subsequent calls during cooldown are ignored
      throttle(() => log.add('task2'));
      throttle(() => log.add('task3'));

      async.elapse(const Duration(milliseconds: 90));
      check(log).deepEquals(['task1']); // task2 and task3 were ignored

      // Cooldown passed, next call executes immediately
      throttle(() => log.add('task4'));
      check(log).deepEquals(['task1', 'task4']);

      throttle.dispose();
    });

    reactiveTest('ThrottleLast waits for duration then executes latest', (
      async,
      log,
    ) {
      final throttle = ThrottleLast(const Duration(milliseconds: 100));

      // First call starts timer but doesn't execute immediately
      throttle(() => log.add('task1'));
      check(log).isEmpty();

      async.elapse(const Duration(milliseconds: 10));

      // Update task during window
      throttle(() => log.add('task2'));

      async.elapse(const Duration(milliseconds: 90));

      // Timer completes, executes latest
      check(log).deepEquals(['task2']);

      throttle.dispose();
    });
  });
}
