import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('checkConnection', () {
    test('returns true when the endpoint accepts', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(server.close);

      final result = await NetworkProbe.checkConnection(
        host: server.address.address,
        port: server.port,
      );
      check(result).isTrue();
    });

    test('returns false on connection refused', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      await server.close();

      final result = await NetworkProbe.checkConnection(
        host: InternetAddress.loopbackIPv4.address,
        port: port,
      );
      check(result).isFalse();
    });

    test('returns false on connection timeout', () async {
      await IOOverrides.runZoned(
        () async {
          final result = await NetworkProbe.checkConnection(
            host: InternetAddress.loopbackIPv4.address,
            port: 80,
          );
          check(result).isFalse();
        },
        socketConnect:
            (host, port, {sourceAddress, sourcePort = 0, timeout}) async {
              throw TimeoutException('Simulated timeout');
            },
      );
    });

    test('propagates non-socket errors', () async {
      await check(
        NetworkProbe.checkConnection(host: 'not-a-literal-ip'),
      ).throws<ArgumentError>();
    });
  });
}
