@TestOn('browser')
@Tags(['web'])
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

@JS('navigator')
external JSObject get _navigator;
@JS('Object.defineProperty')
external void _defineProperty(JSObject target, String key, JSObject desc);

void _stubOnLine({required bool online}) {
  final desc = JSObject()
    ..['configurable'] = true.toJS
    ..['get'] = (() => online.toJS).toJS;
  _defineProperty(_navigator, 'onLine', desc);
  addTearDown(() => _navigator.delete('onLine'.toJS));
}

void main() {
  test('reports navigator.onLine = false as offline', () async {
    _stubOnLine(online: false);
    check(await NetworkProbe.checkConnection()).isFalse();
  });
  test('reports navigator.onLine = true as online', () async {
    _stubOnLine(online: true);
    check(await NetworkProbe.checkConnection()).isTrue();
  });
}
