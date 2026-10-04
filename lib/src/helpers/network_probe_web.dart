import 'dart:js_interop';

@JS('navigator.onLine')
external bool get _onLine;

/// Web implementation of `NetworkProbe.checkConnection`.
Future<bool> probeConnection({
  required String host,
  required int port,
  required Duration timeout,
}) async => _onLine;
