import 'dart:math';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@immutable
final class const _Key(final int id) {
  @override
  bool operator ==(Object other) => other is _Key && other.id == id;

  @override
  int get hashCode => 0;
}

_Key _newKey(int id) => _Key(id);

/// The contract as it stood on a `LinkedHashMap`, kept as the oracle for the
/// differential test below.
final class _LinkedHashMapModel(final int maxEntries) {
  final entries = <Object?, int?>{};

  int? read(Object? key) {
    if (!entries.containsKey(key)) {
      return null;
    }
    final value = entries.remove(key);
    entries[key] = value;
    return value;
  }

  void write(Object? key, int? value) {
    entries.remove(key);
    entries[key] = value;
    if (entries.length > maxEntries) {
      entries.remove(entries.keys.first);
    }
  }
}

double _evictingWriteMicros(int capacity) {
  final cache = LRUCache<int, int>(maxEntries: capacity);
  for (var i = 0; i < capacity; i++) {
    cache[i] = i;
  }
  final stopwatch = Stopwatch()..start();
  for (var i = capacity; i < 2 * capacity; i++) {
    cache[i] = i;
  }
  return stopwatch.elapsedMicroseconds / capacity;
}

void main() {
  group('LRUCache', () {
    test('throws ArgumentError if maxEntries <= 0', () {
      check(() => LRUCache<String, int>(maxEntries: 0)).throws<ArgumentError>();
      LRUCache<String, int> negative() => LRUCache(maxEntries: -1);
      check(negative).throws<ArgumentError>();
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
      check(cache['a']).equals(1);
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
      check(cache['a']).equals(1);
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

    test('peek does not promote', () {
      final cache = LRUCache<String, int>(maxEntries: 2)
        ..['a'] = 1
        ..['b'] = 2;
      check(cache.peek('a')).equals(1);
      check(cache.peek('z')).isNull();
      cache['c'] = 3;
      check(cache.containsKey('a')).isFalse();
      check(cache.containsKey('b')).isTrue();
    });

    test('values and entries are snapshots in LRU order', () {
      final cache = LRUCache<String, int>(maxEntries: 3)
        ..['a'] = 1
        ..['b'] = 2
        ..['c'] = 3;
      check(cache['a']).equals(1);
      check(cache.keys.toList()).deepEquals(['b', 'c', 'a']);
      check(cache.values.toList()).deepEquals([2, 3, 1]);
      check([for (final MapEntry(:key, :value) in cache.entries) '$key=$value'])
          .deepEquals(['b=2', 'c=3', 'a=1']);
      check(() {
        for (final MapEntry(:key, :value) in cache.entries) {
          cache[key] = value + 1;
        }
      }).returnsNormally();
      check(() {
        for (final value in cache.values) {
          cache['d'] = value;
        }
      }).returnsNormally();
    });

    test('reading every value via keys does not throw', () {
      final cache = LRUCache<String, int>(maxEntries: 3)
        ..['a'] = 1
        ..['b'] = 2;
      final values = <int?>[];
      check(() {
        for (final k in cache.keys) {
          values.add(cache[k]);
        }
      }).returnsNormally();
      check(values).deepEquals([1, 2]);
    });

    test('nullable V: stored null is a hit, promotes, and putIfAbsent '
        'skips', () {
      final cache = LRUCache<String, int?>(maxEntries: 2)
        ..['a'] = null
        ..['b'] = 2;
      check(cache['a']).isNull();
      cache['c'] = 3;
      check(cache.containsKey('a')).isTrue();
      check(cache.containsKey('b')).isFalse();
      var calls = 0;
      check(cache.putIfAbsent('a', () => ++calls)).isNull();
      check(calls).equals(0);
    });

    group('removal relinks the recency order', () {
      LRUCache<String, int> filled() => LRUCache<String, int>(maxEntries: 3)
        ..['a'] = 1
        ..['b'] = 2
        ..['c'] = 3;

      for (final (removed, remaining, evicted) in const [
        ('a', ['b', 'c'], 'b'),
        ('b', ['a', 'c'], 'a'),
        ('c', ['a', 'b'], 'a'),
      ]) {
        test('removing $removed keeps $remaining and then evicts $evicted', () {
          final cache = filled();
          check(cache.remove(removed)).isNotNull();
          check(cache.keys.toList()).deepEquals(remaining);
          cache
            ..['d'] = 4
            ..['e'] = 5;
          check(cache.containsKey(evicted)).isFalse();
          check(
            cache.keys.toList(),
          ).deepEquals([...remaining.where((key) => key != evicted), 'd', 'e']);
        });
      }

      test('removing the only entry leaves a usable cache', () {
        final cache = LRUCache<String, int>(maxEntries: 1)..['a'] = 1;
        check(cache.remove('a')).equals(1);
        check(cache.isEmpty).isTrue();
        check(cache.keys).isEmpty();
        cache
          ..['b'] = 2
          ..['c'] = 3;
        check(cache.keys.toList()).deepEquals(['c']);
      });

      test('clear leaves a usable cache', () {
        final cache = filled()
          ..clear()
          ..['x'] = 9;
        check(cache.keys.toList()).deepEquals(['x']);
        check(cache['a']).isNull();
      });

      test('capacity 1 evicts on every new key', () {
        final cache = LRUCache<String, int>(maxEntries: 1)
          ..['a'] = 1
          ..['b'] = 2;
        check(cache.entries.single.key).equals('b');
        check(cache.length).equals(1);
      });
    });

    group('keys', () {
      test('compare with == and hashCode, also across a hash collision', () {
        final cache = LRUCache<_Key, String>(maxEntries: 3)
          ..[_newKey(1)] = 'one'
          ..[_newKey(2)] = 'two';
        check(cache[_newKey(1)]).equals('one');
        check(cache[_newKey(2)]).equals('two');
        check(cache[_newKey(3)]).isNull();
        check(cache.containsKey(_newKey(2))).isTrue();
        check(cache.remove(_newKey(1))).equals('one');
        check(cache.length).equals(1);
      });

      test('a read or write stores the key object it was given', () {
        final first = _newKey(1);
        final second = _newKey(1);
        final third = _newKey(1);
        final cache = LRUCache<_Key, int>(maxEntries: 2)..[first] = 1;

        check(cache[second]).equals(1);
        check(cache.keys.single).identicalTo(second);

        check(cache.putIfAbsent(first, () => 0)).equals(1);
        check(cache.keys.single).identicalTo(first);

        cache[third] = 3;
        check(cache.keys.single).identicalTo(third);
      });

      test('peek and containsKey keep the stored key object', () {
        final stored = _newKey(1);
        final cache = LRUCache<_Key, int>(maxEntries: 2)..[stored] = 1;

        check(cache.peek(_newKey(1))).equals(1);
        check(cache.containsKey(_newKey(1))).isTrue();
        check(cache.keys.single).identicalTo(stored);
      });

      test('null is a key', () {
        final cache = LRUCache<String?, int>(maxEntries: 2)..[null] = 1;
        check(cache[null]).equals(1);
        check(cache.remove(null)).equals(1);
      });

      test('a NaN key is never found and is never evicted', () {
        final cache = LRUCache<double, int>(maxEntries: 1)
          ..[.nan] = 1
          ..[1] = 2
          ..[2] = 3;
        check(cache[.nan]).isNull();
        check(cache.length).equals(3);
      }, testOn: 'vm');
    });

    for (final seed in const [1, 2, 3]) {
      test('behaves as the LinkedHashMap model, seed $seed', () {
        final random = Random(seed);
        Object? pool() => const <Object?>[
          null,
          0,
          1,
          1.0,
          0.0,
          -0.0,
          double.nan,
          'a',
          'b',
          true,
        ][random.nextInt(10)];
        const capacity = 4;
        final cache = LRUCache<Object?, int?>(maxEntries: capacity);
        final model = _LinkedHashMapModel(capacity);

        for (var step = 0; step < 20000; step++) {
          final key = pool();
          final value = random.nextBool() ? step : null;
          final operation = random.nextInt(100);
          final because = 'step $step, operation $operation, key $key';
          if (operation < 40) {
            cache[key] = value;
            model.write(key, value);
          } else if (operation < 70) {
            check(because: because, cache[key]).equals(model.read(key));
          } else if (operation < 80) {
            final hadKey = model.entries.containsKey(key);
            final expected = hadKey ? model.read(key) : value;
            if (!hadKey) {
              model.write(key, value);
            }
            check(
              because: because,
              cache.putIfAbsent(key, () => value),
            ).equals(expected);
          } else if (operation < 90) {
            check(
              because: because,
              cache.remove(key),
            ).equals(model.entries.remove(key));
          } else if (operation < 95) {
            check(because: because, cache.peek(key)).equals(model.entries[key]);
            check(
              because: because,
              cache.containsKey(key),
            ).equals(model.entries.containsKey(key));
          } else if (operation == 99 && step.isEven) {
            cache.clear();
            model.entries.clear();
          }
          check(
            because: because,
            cache.keys.map((key) => '$key').toList(),
          ).deepEquals(model.entries.keys.map((key) => '$key').toList());
          check(
            because: because,
            cache.values.toList(),
          ).deepEquals(model.entries.values.toList());
          check(because: because, cache.length).equals(model.entries.length);
        }
      });
    }

    // A timing oracle: nothing else observes the scan. Minimums, because noise
    // only ever adds time; the old LinkedHashMap scan measured about 70x. Under
    // CPU load the ratio has reached 24, so it runs by hand (dart_test.yaml).
    test('an evicting write costs the same at 100k as at 1k', tags: 'perf', () {
      const limit = 25;
      var small = double.infinity;
      var large = double.infinity;
      for (var round = 0; round < 5; round++) {
        for (var i = 0; i < 20; i++) {
          small = min(small, _evictingWriteMicros(1000));
        }
        large = min(large, _evictingWriteMicros(100000));
        if (large / small < limit) break;
      }
      printOnFailure('1k: $small us/write, 100k: $large us/write');
      check(large / small).isLessThan(limit);
    });
  });
}
