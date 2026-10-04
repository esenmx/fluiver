import 'package:fluiver/src/helpers/network_probe_io.dart'
    if (dart.library.js_interop) 'package:fluiver/src/helpers/network_probe_web.dart';

/// Lightweight reachability probes.
abstract final class NetworkProbe {
  /// Returns `true` if a TCP socket to `host:port` — Cloudflare DNS
  /// (`1.0.0.1:53`) by default — opens within [timeout].
  ///
  /// Skips DNS resolution by connecting to a literal IP — faster and more
  /// reliable than HTTP probes. [host] must be a literal IPv4/IPv6 address;
  /// point it at your own endpoint when Cloudflare is unreachable by policy
  /// (corporate networks, some regions). Returns `false` on
  /// `SocketException` or `TimeoutException`; other errors propagate (let
  /// bugs escape).
  ///
  /// The default [timeout] of 3 seconds covers two lost SYNs (TCP
  /// retransmits at ~1s intervals), so a lossy-but-usable mobile network
  /// still reports `true`.
  ///
  /// On web this returns the browser's `navigator.onLine` (`false` only when
  /// the browser knows it is offline); [host], [port] and [timeout] are
  /// ignored there.
  static Future<bool> checkConnection({
    String host = '1.0.0.1',
    int port = 53,
    Duration timeout = const Duration(seconds: 3),
  }) => probeConnection(host: host, port: port, timeout: timeout);
}
