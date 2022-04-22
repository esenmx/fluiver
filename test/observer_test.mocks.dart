// Mocks generated by Mockito 5.1.0 from annotations
// in fluiver/test/observer_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:ui' as _i3;

import 'package:fluiver/fluiver.dart' as _i2;
import 'package:flutter/material.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [LocaleObserver].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocaleObserver extends _i1.Mock implements _i2.LocaleObserver {
  MockLocaleObserver() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void didChangeLocales(List<_i3.Locale>? locales) =>
      super.noSuchMethod(Invocation.method(#didChangeLocales, [locales]),
          returnValueForMissingStub: null);
  @override
  _i4.Future<bool> didPopRoute() =>
      (super.noSuchMethod(Invocation.method(#didPopRoute, []),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<bool> didPushRoute(String? route) =>
      (super.noSuchMethod(Invocation.method(#didPushRoute, [route]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<bool> didPushRouteInformation(
          _i5.RouteInformation? routeInformation) =>
      (super.noSuchMethod(
          Invocation.method(#didPushRouteInformation, [routeInformation]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  void didChangeMetrics() =>
      super.noSuchMethod(Invocation.method(#didChangeMetrics, []),
          returnValueForMissingStub: null);
  @override
  void didChangeTextScaleFactor() =>
      super.noSuchMethod(Invocation.method(#didChangeTextScaleFactor, []),
          returnValueForMissingStub: null);
  @override
  void didChangePlatformBrightness() =>
      super.noSuchMethod(Invocation.method(#didChangePlatformBrightness, []),
          returnValueForMissingStub: null);
  @override
  void didChangeAppLifecycleState(_i3.AppLifecycleState? state) => super
      .noSuchMethod(Invocation.method(#didChangeAppLifecycleState, [state]),
          returnValueForMissingStub: null);
  @override
  void didHaveMemoryPressure() =>
      super.noSuchMethod(Invocation.method(#didHaveMemoryPressure, []),
          returnValueForMissingStub: null);
  @override
  void didChangeAccessibilityFeatures() =>
      super.noSuchMethod(Invocation.method(#didChangeAccessibilityFeatures, []),
          returnValueForMissingStub: null);
}
