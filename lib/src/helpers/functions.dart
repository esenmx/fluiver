part of '../../fluiver.dart';

/// Checks whether the device has a connection to the internet or not
/// Reference: [https://stackoverflow.com/a/49648870/10380182]
Future<bool> hasDeviceConnection() {
  return InternetAddress.lookup('example.com')
      .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
      .onError<SocketException>((_, _) => false);
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

/// Executes the appropriate callback based on the current platform.
///
/// Use [android] for Android devices.
/// Use [fuchsia] for Fuchsia devices.
/// Use [ios] for iOS devices.
/// Use [linux] for Linux devices.
/// Use [macOS] for MacOS devices.
/// Use [windows] for Windows devices.
/// Use [web] for Web devices.
T platformSpecific<T>({
  T Function()? android,
  T Function()? fuchsia,
  T Function()? ios,
  T Function()? linux,
  T Function()? macOS,
  T Function()? windows,
  T Function()? web,
}) {
  final T Function()? callback;
  if (kIsWeb) {
    callback = web;
  } else {
    callback = switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.fuchsia => fuchsia,
      TargetPlatform.iOS => ios,
      TargetPlatform.linux => linux,
      TargetPlatform.macOS => macOS,
      TargetPlatform.windows => windows,
    };
  }

  if (callback != null) {
    return callback();
  }

  throw UnsupportedError(kIsWeb ? 'Web' : defaultTargetPlatform.name);
}
