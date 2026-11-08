import 'dart:collection';

/// Fixed-capacity LRU (least-recently-used) cache.
///
/// Reads and writes mark the entry as most-recently-used. When [maxEntries]
/// is exceeded, the least-recently-used entry is evicted.
///
/// ```dart
/// final cache = LRUCache<String, User>(maxEntries: 100);
/// cache[user.id] = user;
/// final hit = cache[user.id]; // marks as recent
/// cache.remove(user.id);
/// cache.clear();
/// ```
///
/// Backed by a [HashMap] plus a doubly linked list — O(1) reads, writes, and
/// eviction, whatever the capacity. Not thread-safe; isolates each have their
/// own cache.
final class LRUCache<K, V>({
  /// Maximum number of entries the cache holds before evicting.
  required final int maxEntries,
}) {
  /// Creates a cache that holds at most [maxEntries] entries.
  ///
  /// [maxEntries] must be strictly positive.
  this {
    if (maxEntries <= 0) {
      throw ArgumentError('maxEntries must be greater than 0');
    }
  }
  final HashMap<K, _LRUNode<K, V>> _nodes = HashMap<K, _LRUNode<K, V>>();
  _LRUNode<K, V>? _leastRecent;
  _LRUNode<K, V>? _mostRecent;

  /// Number of entries currently held.
  int get length => _nodes.length;

  /// Whether the cache holds no entries.
  bool get isEmpty => _nodes.isEmpty;

  /// Whether the cache holds at least one entry.
  bool get isNotEmpty => _nodes.isNotEmpty;

  /// Returns the value for [key], promoting it to most-recently-used, or
  /// `null` if absent.
  V? operator [](K key) {
    final node = _take(key);
    if (node == null) {
      return null;
    }
    _insertMostRecent(node..key = key);
    return node.value;
  }

  /// Inserts or replaces [value] for [key] and marks it most-recently-used.
  /// Evicts the least-recently-used entry when [maxEntries] is exceeded.
  void operator []=(K key, V value) {
    _take(key);
    _insertMostRecent(_LRUNode(key, value));
    if (_nodes.length > maxEntries) {
      if (_leastRecent case final evicted?) {
        _take(evicted.key);
      }
    }
  }

  /// Returns the cached value for [key], promoting it to most-recently-used.
  /// On miss, computes [ifAbsent], stores it, and returns the new value.
  ///
  /// ```dart
  /// final user = userCache.putIfAbsent(id, () => loadUser(id));
  /// ```
  ///
  /// [ifAbsent] runs synchronously; for async loads keep the cache typed on
  /// the future (`LRUCache<K, Future<V>>`) so concurrent misses dedupe.
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (_take(key) case final node?) {
      _insertMostRecent(node..key = key);
      return node.value;
    }
    final value = ifAbsent();
    this[key] = value;
    return value;
  }

  /// Returns `true` if [key] is present (without promoting it).
  bool containsKey(K key) => _nodes.containsKey(key);

  /// Removes [key] and returns its value, or `null` if absent.
  V? remove(K key) => _take(key)?.value;

  /// Empties the cache.
  void clear() {
    _nodes.clear();
    _leastRecent = null;
    _mostRecent = null;
  }

  /// Returns the value for [key] without promoting it, or `null` if absent.
  V? peek(K key) => _nodes[key]?.value;

  /// Keys in least- to most-recently-used order, as a snapshot.
  Iterable<K> get keys => List.unmodifiable(_nodesInOrder().map((n) => n.key));

  /// Values in least- to most-recently-used order, as a snapshot.
  Iterable<V> get values =>
      List.unmodifiable(_nodesInOrder().map((n) => n.value));

  /// Entries in least- to most-recently-used order, as a snapshot.
  Iterable<MapEntry<K, V>> get entries =>
      List.unmodifiable(_nodesInOrder().map((n) => MapEntry(n.key, n.value)));

  Iterable<_LRUNode<K, V>> _nodesInOrder() sync* {
    for (var node = _leastRecent; node != null; node = node.moreRecent) {
      yield node;
    }
  }

  _LRUNode<K, V>? _take(K key) {
    final node = _nodes.remove(key);
    if (node == null) {
      return null;
    }
    final lessRecent = node.lessRecent;
    final moreRecent = node.moreRecent;
    if (lessRecent == null) {
      _leastRecent = moreRecent;
    } else {
      lessRecent.moreRecent = moreRecent;
    }
    if (moreRecent == null) {
      _mostRecent = lessRecent;
    } else {
      moreRecent.lessRecent = lessRecent;
    }
    return node
      ..lessRecent = null
      ..moreRecent = null;
  }

  void _insertMostRecent(_LRUNode<K, V> node) {
    _nodes[node.key] = node;
    final previous = _mostRecent;
    node.lessRecent = previous;
    if (previous == null) {
      _leastRecent = node;
    } else {
      previous.moreRecent = node;
    }
    _mostRecent = node;
  }
}

final class _LRUNode<K, V>(var K key, final V value) {
  _LRUNode<K, V>? lessRecent;
  _LRUNode<K, V>? moreRecent;
}
