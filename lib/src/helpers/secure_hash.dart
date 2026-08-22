part of '../../fluiver.dart';

/// Cryptographic string hashing.
///
/// Works across all platforms including JS Web.
abstract final class SecureHash {
  /// SHA-256 hash of [s] returned as a hex string.
  ///
  /// Secure cryptographic hash function.
  static String sha256(String s) {
    final bytes = utf8.encode(s);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
