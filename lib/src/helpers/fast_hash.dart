part of '../../fluiver.dart';

/// Non-cryptographic string hashing.
///
/// Not available on JS web ([fnv1a] throws there): JavaScript's 53-bit
/// integer limit corrupts 64-bit arithmetic. VM and Wasm targets have
/// native 64-bit ints and work fine.
abstract final class FastHash {
  static const bool _isJS = kIsWeb && !kIsWasm;

  /// FNV-1a 64-bit hash of [s].
  ///
  /// Stable across runs and Dart versions; suitable for hash-map keys,
  /// cache shards, and deduplication. NOT a cryptographic hash.
  ///
  /// Throws [UnsupportedError] on JS web builds; Wasm is fine.
  static int fnv1a(String s) {
    if (_isJS) {
      throw UnsupportedError(
        'FastHash.fnv1a needs 64-bit ints: '
        'JS 53-bit integers corrupt FNV arithmetic. VM and Wasm are fine.',
      );
    }
    const fnvPrime = 0x100000001b3;
    // Offset basis 0xcbf29ce484222325, split because a >2^53 literal is a
    // compile error on JS targets even when the function is never called.
    var hash = (0xcbf29ce4 << 32) | 0x84222325;
    for (var i = 0; i < s.length; i++) {
      final codeUnit = s.codeUnitAt(i);
      hash ^= codeUnit >> 8;
      hash *= fnvPrime;
      hash ^= codeUnit & 0xFF;
      hash *= fnvPrime;
    }
    return hash;
  }
}
