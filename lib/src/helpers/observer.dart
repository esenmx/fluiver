part of '../../fluiver.dart';

/// Observes locale changes via [WidgetsBindingObserver].
///
/// Construct, register via `WidgetsBinding.instance.addObserver(...)`,
/// and remove on dispose. Works from any state container — a plain
/// [StatefulWidget], a [ValueNotifier], or a Riverpod / BLoC notifier.
///
/// ```dart
/// class _MyAppState extends State<MyApp> {
///   late final LocaleObserver _observer = LocaleObserver((locales) {
///     // react to locale change
///   });
///
///   @override
///   void initState() {
///     super.initState();
///     WidgetsBinding.instance.addObserver(_observer);
///   }
///
///   @override
///   void dispose() {
///     WidgetsBinding.instance.removeObserver(_observer);
///     super.dispose();
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
/// ```dart
/// final observer = BrightnessObserver((brightness) {
///   // react to brightness change
/// });
/// WidgetsBinding.instance.addObserver(observer);
/// // ...
/// WidgetsBinding.instance.removeObserver(observer);
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
/// ```dart
/// final observer = AppLifecycleObserver((state) {
///   // react to lifecycle change
/// });
/// WidgetsBinding.instance.addObserver(observer);
/// // ...
/// WidgetsBinding.instance.removeObserver(observer);
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
