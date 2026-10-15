import 'dart:js_interop';

@JS('navigator.onLine')
external bool get _onLine;

/// Web implementation of `NetworkProbe.checkConnection`.
Future<bool> probeConnection({
  required String host,
  required int port,
  required Duration timeout,
}) => throw UnsupportedError(
  'NetworkProbe.checkConnection needs TCP sockets, which web does not have; '
  'use isBrowserOnline.',
);

/// Web implementation of `NetworkProbe.isBrowserOnline`.
bool browserOnline() => _onLine;
