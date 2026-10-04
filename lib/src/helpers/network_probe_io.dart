import 'dart:async';
import 'dart:io' show InternetAddress, Socket, SocketException;

/// Native implementation of `NetworkProbe.checkConnection`.
Future<bool> probeConnection({
  required String host,
  required int port,
  required Duration timeout,
}) async {
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
