part of '../../fluiver.dart';

/// Observes locale changes via [WidgetsBindingObserver].
///
/// Example:
/// ```dart
///  final localesProvider = Provider<List<Locale>?>((ref) {
///    final observer = LocaleObserver((locales) => ref.state = locales);
///    WidgetsBinding.instance.addObserver(observer);
///    ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///    return PlatformDispatcher.instance.locales;
///  });
/// ```
class LocaleObserver extends WidgetsBindingObserver {
  LocaleObserver(this.onLocalesChanged);

  final void Function(List<Locale>? locales) onLocalesChanged;

  @override
  void didChangeLocales(List<Locale>? locales) {
    onLocalesChanged(locales);
    super.didChangeLocales(locales);
  }
}

/// Observes platform brightness changes via [WidgetsBindingObserver].
///
/// Example:
/// ```dart
/// final brightnessProvider = Provider<Brightness>((ref) {
///   final observer = BrightnessObserver((brightness) => ref.state = brightness);
///   WidgetsBinding.instance.addObserver(observer);
///   ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///   return PlatformDispatcher.instance.platformBrightness;
/// });
/// ```
class BrightnessObserver extends WidgetsBindingObserver {
  BrightnessObserver(this.onPlatformBrightnessChanged);

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
/// Example:
/// ```dart
/// final appLifecycleStateProvider = Provider<AppLifecycleState?>((ref) {
///   final observer = AppLifecycleObserver((state) => ref.state = state);
///   WidgetsBinding.instance.addObserver(observer);
///   ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
///   return WidgetsBinding.instance.lifecycleState;
/// });
/// ```
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver(this.onAppLifecycleStateChange);

  final void Function(AppLifecycleState state) onAppLifecycleStateChange;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onAppLifecycleStateChange(state);
    super.didChangeAppLifecycleState(state);
  }
}
