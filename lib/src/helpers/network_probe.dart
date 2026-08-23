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

  /// Returns `true` if a TLS socket to `host:port` — Cloudflare DNS over TLS
  /// (`1.0.0.1:853`) by default — establishes a secure connection within
  /// [timeout].
  ///
  /// Similar to [checkConnection], but performs a full TLS handshake. Useful
  /// for unmasking transparent TCP/53 interception that makes the plain probe
  /// report a false `true`.
  ///
  /// Specify [onBadCertificate] to override the default certificate validation
  /// (e.g. for testing with self-signed certificates). Specify [context] to
  /// provide a custom `SecurityContext`.
  static Future<bool> checkTlsConnection({
    String host = '1.0.0.1',
    int port = 853,
    Duration timeout = const Duration(seconds: 3),
    SecurityContext? context,
    bool Function(X509Certificate)? onBadCertificate,
  }) async {
    if (kIsWeb) {
      return true;
    }
    try {
      final socket = await SecureSocket.connect(
        InternetAddress(host),
        port,
        context: context,
        onBadCertificate: onBadCertificate,
        timeout: timeout,
      ).timeout(timeout);
      await socket.close();
      return true;
    } on SocketException {
      return false;
    } on TlsException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}
