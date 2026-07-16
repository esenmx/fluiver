import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LRUCache', () {
    test('throws ArgumentError if maxEntries <= 0', () {
      check(() => LRUCache<String, int>(maxEntries: 0)).throws<ArgumentError>();
      check(() => LRUCache<String, int>(maxEntries: -1)).throws<ArgumentError>();
    });

    test('stores and reads values', () {
      final cache = LRUCache<String, int>(maxEntries: 3);
      cache['a'] = 1;
      check(cache['a']).equals(1);
      check(cache.length).equals(1);
    });

    test('evicts least-recently-used when full', () {
      final cache = LRUCache<String, int>(maxEntries: 2)
        ..['a'] = 1
        ..['b'] = 2
        ..['c'] = 3;
      check(cache.containsKey('a')).isFalse();
      check(cache.containsKey('b')).isTrue();
      check(cache.containsKey('c')).isTrue();
    });

    test('reading an entry promotes it to most-recently-used', () {
      final cache = LRUCache<String, int>(maxEntries: 2)
        ..['a'] = 1
        ..['b'] = 2;
      final _ = cache['a'];
      cache['c'] = 3;
      check(cache.containsKey('a')).isTrue();
      check(cache.containsKey('b')).isFalse();
      check(cache.containsKey('c')).isTrue();
    });

    test('reassigning a key promotes it', () {
      final cache = LRUCache<String, int>(maxEntries: 2)
        ..['a'] = 1
        ..['b'] = 2
        ..['a'] = 10
        ..['c'] = 3;
      check(cache['a']).equals(10);
      check(cache.containsKey('b')).isFalse();
    });

    test('reads missing key returns null', () {
      final cache = LRUCache<String, int>(maxEntries: 2);
      check(cache['absent']).isNull();
    });

    test('remove drops entry', () {
      final cache = LRUCache<String, int>(maxEntries: 2)..['a'] = 1;
      check(cache.remove('a')).equals(1);
      check(cache.containsKey('a')).isFalse();
      check(cache.remove('a')).isNull();
    });

    test('clear empties the cache', () {
      final cache = LRUCache<String, int>(maxEntries: 2)
        ..['a'] = 1
        ..['b'] = 2
        ..clear();
      check(cache.isEmpty).isTrue();
      check(cache.length).equals(0);
    });

    test('keys are in least- to most-recently-used order', () {
      final cache = LRUCache<String, int>(maxEntries: 3)
        ..['a'] = 1
        ..['b'] = 2
        ..['c'] = 3;
      final _ = cache['a'];
      check(cache.keys.toList()).deepEquals(['b', 'c', 'a']);
    });

    group('putIfAbsent', () {
      test('computes and stores on miss', () {
        final cache = LRUCache<String, int>(maxEntries: 2);
        var calls = 0;

        final v = cache.putIfAbsent('a', () {
          calls++;
          return 42;
        });

        check(v).equals(42);
        check(calls).equals(1);
        check(cache['a']).equals(42);
      });

      test('returns existing value without running factory', () {
        final cache = LRUCache<String, int>(maxEntries: 2)..['a'] = 1;
        var calls = 0;

        final v = cache.putIfAbsent('a', () {
          calls++;
          return 99;
        });

        check(v).equals(1);
        check(calls).equals(0);
      });

      test('hit promotes the entry to most-recently-used', () {
        final cache = LRUCache<String, int>(maxEntries: 2)
          ..['a'] = 1
          ..['b'] = 2
          ..putIfAbsent('a', () => 99) // hit; should promote 'a'.
          ..['c'] = 3; // evicts 'b', not 'a'.

        check(cache.containsKey('a')).isTrue();
        check(cache.containsKey('b')).isFalse();
        check(cache.containsKey('c')).isTrue();
      });
    });
  });
}
