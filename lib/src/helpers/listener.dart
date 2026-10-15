import 'package:flutter/widgets.dart';

/// Reports system locale changes, like the framework's
/// [AppLifecycleListener]: it registers with [WidgetsBinding] on
/// construction and stops on [dispose].
///
/// Designed for providers — `flutter_hooks` does not ship a locale
/// hook. For widget-local consumption inside a hook widget, do it
/// inline with the `WidgetsBindingObserver` mixin instead.
///
/// ```dart
/// @riverpod
/// class LocalesNotifier extends _$LocalesNotifier {
///   @override
///   List<Locale>? build() {
///     final listener = LocaleListener((locales) => state = locales);
///     ref.onDispose(listener.dispose);
///     return PlatformDispatcher.instance.locales;
///   }
/// }
/// ```
final class LocaleListener(
  /// Called with the new locale list on every system locale change.
  final void Function(List<Locale>? locales) onLocalesChanged,
) {
  /// Creates a listener that invokes [onLocalesChanged] on every system
  /// locale change until [dispose].
  this {
    _binding.addObserver(_observer);
  }

  final WidgetsBinding _binding = WidgetsBinding.instance;
  final _observer = _LocaleObserver(onLocalesChanged);

  /// Stops reporting locale changes.
  ///
  /// Throws [StateError] if called more than once.
  void dispose() {
    if (_observer.disposed) {
      throw StateError('LocaleListener was used after being disposed.');
    }
    _observer.disposed = true;
    _binding.removeObserver(_observer);
  }
}

final class _LocaleObserver(
  final void Function(List<Locale>? locales) onLocalesChanged,
) with WidgetsBindingObserver {
  bool disposed = false;

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (!disposed) {
      onLocalesChanged(locales);
    }
  }
}

/// Reports platform brightness changes, like the framework's
/// [AppLifecycleListener]: it registers with [WidgetsBinding] on
/// construction and stops on [dispose].
///
/// For widget context prefer `flutter_hooks.useOnPlatformBrightnessChange`;
/// this listener is for provider code where hooks don't apply.
///
/// ```dart
/// @riverpod
/// class BrightnessNotifier extends _$BrightnessNotifier {
///   @override
///   Brightness build() {
///     final listener = BrightnessListener((b) => state = b);
///     ref.onDispose(listener.dispose);
///     return PlatformDispatcher.instance.platformBrightness;
///   }
/// }
/// ```
final class BrightnessListener(
  /// Called with the new brightness on every platform brightness change.
  final void Function(Brightness brightness) onPlatformBrightnessChanged,
) {
  /// Creates a listener that invokes [onPlatformBrightnessChanged] on every
  /// platform brightness change until [dispose].
  this {
    _binding.addObserver(_observer);
  }

  final WidgetsBinding _binding = WidgetsBinding.instance;
  final _observer = _BrightnessObserver(onPlatformBrightnessChanged);

  /// Stops reporting brightness changes.
  ///
  /// Throws [StateError] if called more than once.
  void dispose() {
    if (_observer.disposed) {
      throw StateError('BrightnessListener was used after being disposed.');
    }
    _observer.disposed = true;
    _binding.removeObserver(_observer);
  }
}

final class _BrightnessObserver(
  final void Function(Brightness brightness) onPlatformBrightnessChanged,
) with WidgetsBindingObserver {
  bool disposed = false;

  @override
  void didChangePlatformBrightness() {
    if (!disposed) {
      onPlatformBrightnessChanged(
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
      );
    }
  }
}
