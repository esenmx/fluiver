part of fluiver;

/// Example:
/// ```dart
///  final localesProvider = Provider<List<Locale>?>((ref) {
///    final observer = LocaleObserver((locales) => ref.state = locales);
///    WidgetsBinding.instance!.addObserver(observer);
///    ref.onDispose(() => WidgetsBinding.instance!.removeObserver(observer));
///  });
/// ```
class LocaleObserver extends WidgetsBindingObserver {
  LocaleObserver(this._didChangeLocales);

  final void Function(List<Locale>? locales) _didChangeLocales;

  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
    super.didChangeLocales(locales);
  }
}

/// Example:
/// ```dart
/// final themesProvider = Provider<Brightness?>((ref) {
///   final observer = BrightnessObserver((brightness) => ref.state = brightness);
///   WidgetsBinding.instance!.addObserver(observer);
///   ref.onDispose(() => WidgetsBinding.instance!.removeObserver(observer));
/// });
/// ```
class BrightnessObserver extends WidgetsBindingObserver {
  BrightnessObserver(this.onPlatformBrightnessChanged);

  final void Function(Brightness) onPlatformBrightnessChanged;

  @override
  void didChangePlatformBrightness() {
    onPlatformBrightnessChanged(_window.platformBrightness);
    super.didChangePlatformBrightness();
  }
}

/// Example:
/// ```dart
/// final appLifecycleStateProvider = Provider<AppLifecycleState?>((ref) {
///   final observer = AppLifecycleObserver((state) => ref.state = state);
///   WidgetsBinding.instance!.addObserver(observer);
///   ref.onDispose(() => WidgetsBinding.instance!.removeObserver(observer));
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

ui.SingletonFlutterWindow get _window => WidgetsBinding.instance.window;
