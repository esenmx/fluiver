part of '../../fluiver.dart';

/// Observes locale changes via [WidgetsBindingObserver].
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
///     final observer = LocaleObserver((locales) => state = locales);
///     WidgetsBinding.instance.addObserver(observer);
///     ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///     return PlatformDispatcher.instance.locales;
///   }
/// }
/// ```
class LocaleObserver extends WidgetsBindingObserver {
  /// Creates an observer that invokes [onLocalesChanged] when system
  /// locales change.
  LocaleObserver(this.onLocalesChanged);

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
/// this observer is for provider code where hooks don't apply.
///
/// ```dart
/// @riverpod
/// class BrightnessNotifier extends _$BrightnessNotifier {
///   @override
///   Brightness build() {
///     final observer = BrightnessObserver((b) => state = b);
///     WidgetsBinding.instance.addObserver(observer);
///     ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///     return PlatformDispatcher.instance.platformBrightness;
///   }
/// }
/// ```
class BrightnessObserver extends WidgetsBindingObserver {
  /// Creates an observer that invokes [onPlatformBrightnessChanged] when
  /// the platform brightness changes.
  BrightnessObserver(this.onPlatformBrightnessChanged);

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

/// Observes app lifecycle state changes via [WidgetsBindingObserver].
///
/// For widget context prefer `flutter_hooks.useOnAppLifecycleStateChange`;
/// this observer is for provider code where hooks don't apply.
///
/// ```dart
/// @riverpod
/// class AppLifecycleNotifier extends _$AppLifecycleNotifier {
///   @override
///   AppLifecycleState? build() {
///     final observer = AppLifecycleObserver((s) => state = s);
///     WidgetsBinding.instance.addObserver(observer);
///     ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///     return WidgetsBinding.instance.lifecycleState;
///   }
/// }
/// ```
class AppLifecycleObserver extends WidgetsBindingObserver {
  /// Creates an observer that invokes [onAppLifecycleStateChange] when the
  /// app lifecycle state changes.
  AppLifecycleObserver(this.onAppLifecycleStateChange);

  /// Called with the new lifecycle state on every change.
  final void Function(AppLifecycleState state) onAppLifecycleStateChange;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onAppLifecycleStateChange(state);
    super.didChangeAppLifecycleState(state);
  }
}
