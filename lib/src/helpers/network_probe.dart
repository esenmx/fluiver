part of '../../fluiver.dart';

/// Lightweight reachability probes.
abstract final class NetworkProbe {
  /// Returns `true` if a TCP socket to `host:port` — Cloudflare DNS
  /// (`1.0.0.1:53`) by default — opens within [timeout].
  ///
  /// Skips DNS resolution by connecting to a literal IP — faster and more
  /// reliable than HTTP probes. [host] must be a literal IPv4/IPv6 address;
  /// point it at your own endpoint when Cloudflare is unreachable by policy
  /// (corporate networks, some regions). Returns `false` on
  /// [SocketException] or [TimeoutException]; other errors propagate (let
  /// bugs escape).
  ///
  /// The default [timeout] of 3 seconds covers two lost SYNs (TCP
  /// retransmits at ~1s intervals), so a lossy-but-usable mobile network
  /// still reports `true`.
  ///
  /// On web this short-circuits to `true` — `dart:io.Socket` is unavailable
  /// in the browser, and a running web app is by definition online.
  static Future<bool> checkConnection({
    String host = '1.0.0.1',
    int port = 53,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (kIsWeb) {
      return true;
    }
    try {
      final socket = await Socket.connect(
        InternetAddress(host),
        port,
        timeout: timeout,
      );
      await socket.close();
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}
