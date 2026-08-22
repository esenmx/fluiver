import 'dart:io';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('checkConnection', () {
    test('returns true when the endpoint accepts', () async {
      // Connect to Google DNS over TLS as an integration test.
      // This avoids mocking a local secure server without valid certificates.
      final result = await NetworkProbe.checkConnection(
        host: '8.8.8.8',
      );
      check(result).isTrue();
    });

    test('returns false on connection refused', () async {
      final result = await NetworkProbe.checkConnection(
        host: InternetAddress.loopbackIPv4.address,
        port: 55555,
      );
      check(result).isFalse();
    });

    test('propagates non-socket errors', () async {
      await check(
        NetworkProbe.checkConnection(host: 'not-a-literal-ip'),
      ).throws<ArgumentError>();
    });
  });
}
