part of '../../fluiver.dart';

/// Non-cryptographic string hashing.
///
/// VM only — NOT Web. JavaScript's 53-bit integer limit corrupts 64-bit
/// arithmetic on web targets.
abstract final class FastHash {
  /// FNV-1a 64-bit hash of [s].
  ///
  /// Stable across runs and Dart versions; suitable for hash-map keys,
  /// cache shards, and deduplication. NOT a cryptographic hash.
  static int fnv1a(String s) {
    const fnvPrime = 0x100000001b3;
    var hash = 0xcbf29ce484222325;
    for (final codeUnit in s.codeUnits) {
      hash ^= codeUnit >> 8;
      hash *= fnvPrime;
      hash ^= codeUnit & 0xFF;
      hash *= fnvPrime;
    }
    return hash;
  }
}
