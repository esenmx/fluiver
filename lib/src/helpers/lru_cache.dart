part of '../../fluiver.dart';

/// Fixed-capacity LRU (least-recently-used) cache.
///
/// Reads and writes mark the entry as most-recently-used. When [maxEntries]
/// is exceeded, the least-recently-used entry is evicted.
///
/// ```dart
/// final cache = LRUCache<String, User>(maxEntries: 100);
/// cache['alice'] = user;
/// final hit = cache['alice'];                  // marks as recent
/// cache.remove('alice');
/// cache.clear();
/// ```
///
/// Backed by [LinkedHashMap] insertion order — O(1) reads, writes, and
/// eviction. Not thread-safe; isolates each have their own cache.
class LRUCache<K, V> {
  /// Creates a cache that holds at most [maxEntries] entries.
  ///
  /// [maxEntries] must be strictly positive.
  LRUCache({required this.maxEntries})
    : assert(maxEntries > 0, 'maxEntries must be greater than 0');

  /// Maximum number of entries the cache holds before evicting.
  final int maxEntries;
  final LinkedHashMap<K, V> _entries = LinkedHashMap<K, V>();

  /// Number of entries currently held.
  int get length => _entries.length;

  /// Whether the cache holds no entries.
  bool get isEmpty => _entries.isEmpty;

  /// Whether the cache holds at least one entry.
  bool get isNotEmpty => _entries.isNotEmpty;

  /// Returns the value for [key], promoting it to most-recently-used, or
  /// `null` if absent.
  V? operator [](K key) {
    if (!_entries.containsKey(key)) {
      return null;
    }
    final value = _entries.remove(key) as V;
    _entries[key] = value;
    return value;
  }

  /// Inserts or replaces [value] for [key] and marks it most-recently-used.
  /// Evicts the least-recently-used entry when [maxEntries] is exceeded.
  void operator []=(K key, V value) {
    _entries.remove(key);
    _entries[key] = value;
    if (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }
  }

  /// Returns `true` if [key] is present (without promoting it).
  bool containsKey(K key) => _entries.containsKey(key);

  /// Removes [key] and returns its value, or `null` if absent.
  V? remove(K key) => _entries.remove(key);

  /// Empties the cache.
  void clear() => _entries.clear();

  /// Keys in least- to most-recently-used order.
  Iterable<K> get keys => _entries.keys;
}
