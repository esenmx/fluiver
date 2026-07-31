part of '../../fluiver.dart';

/// Observes locale changes via [WidgetsBindingObserver].
///
/// Designed for providers — `flutter_hooks` does not ship a locale
/// hook. For widget-local consumption inside a hook widget, do it
/// inline with the `WidgetsBindingObserver` mixin instead.
///
/// Named `*Listener` to match the framework's `AppLifecycleListener`.
///
/// ```dart
/// @riverpod
/// class LocalesNotifier extends _$LocalesNotifier {
///   @override
///   List<Locale>? build() {
///     final listener = LocaleListener((locales) => state = locales);
///     WidgetsBinding.instance.addObserver(listener);
///     ref.onDispose(() => WidgetsBinding.instance.removeObserver(listener));
///     return PlatformDispatcher.instance.locales;
///   }
/// }
/// ```
class LocaleListener extends WidgetsBindingObserver {
  /// Creates a listener that invokes [onLocalesChanged] when system
  /// locales change.
  LocaleListener(this.onLocalesChanged);

  /// Called with the new locale list on every system locale change.
  final void Function(List<Locale>? locales) onLocalesChanged;

  @override
  void didChangeLocales(List<Locale>? locales) {
    onLocalesChanged(locales);
    super.didChangeLocales(locales);
  }
}

/// Observes platform brightness changes via [WidgetsBindingObserver].
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
///     WidgetsBinding.instance.addObserver(listener);
///     ref.onDispose(() => WidgetsBinding.instance.removeObserver(listener));
///     return PlatformDispatcher.instance.platformBrightness;
///   }
/// }
/// ```
class BrightnessListener extends WidgetsBindingObserver {
  /// Creates a listener that invokes [onPlatformBrightnessChanged] when
  /// the platform brightness changes.
  BrightnessListener(this.onPlatformBrightnessChanged);

  /// Called with the new brightness on every platform brightness change.
  final void Function(Brightness brightness) onPlatformBrightnessChanged;

  @override
  void didChangePlatformBrightness() {
    onPlatformBrightnessChanged(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    super.didChangePlatformBrightness();
  }
}
