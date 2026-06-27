part of '../../fluiver.dart';

/// Lightweight reachability probes.
abstract final class NetworkProbe {
  /// Returns `true` if a TCP socket to Cloudflare DNS (`1.0.0.1:53`) opens
  /// within [timeout].
  ///
  /// Skips DNS resolution by connecting to a literal IP — faster and more
  /// reliable than HTTP probes. Returns `false` on [SocketException] or
  /// [TimeoutException]; other errors propagate (let bugs escape).
  ///
  /// On web this short-circuits to `true` — `dart:io.Socket` is unavailable
  /// in the browser, and a running web app is by definition online.
  static Future<bool> hasConnection({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    if (kIsWeb) {
      return true;
    }
    try {
      final socket = await Socket.connect(
        InternetAddress('1.0.0.1', type: InternetAddressType.IPv4),
        53,
        timeout: timeout,
      );
      unawaited(socket.close());
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}
