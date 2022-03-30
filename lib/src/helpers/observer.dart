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
  BrightnessObserver(this._didChangePlatformBrightness);

  final void Function(Brightness) _didChangePlatformBrightness;

  @override
  void didChangePlatformBrightness() {
    _didChangePlatformBrightness(
        WidgetsBinding.instance!.window.platformBrightness);
    super.didChangePlatformBrightness();
  }
}
