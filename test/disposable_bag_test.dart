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
      await Future<void>.delayed(Duration.zero);
      check(calls).deepEquals(['late']);
      check(bag.length).equals(0);
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
  });
}
