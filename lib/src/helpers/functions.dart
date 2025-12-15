part of '../../fluiver.dart';

/// Checks whether the device has a connection to the internet or not
/// Reference: [https://stackoverflow.com/a/49648870/10380182]
Future<bool> hasDeviceConnection() {
  return InternetAddress.lookup('example.com')
      .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
      .catchError((error) => false);
}

/// FNV-1a 64-bit hash algorithm optimized for Dart Strings (VM Only).
///
/// Note: This is NOT safe for Web (JavaScript) due to 53-bit integer limits.
int fastHash(String string) {
  // FNV-1a 64-bit constants
  const fnvPrime = 0x100000001b3;
  var hash = 0xcbf29ce484222325;
  for (final codeUnit in string.codeUnits) {
    // Process high byte
    hash ^= codeUnit >> 8;
    hash *= fnvPrime;
    // Process low byte
    hash ^= codeUnit & 0xFF;
    hash *= fnvPrime;
  }
  return hash;
}
