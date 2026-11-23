# fluiver widgets, timing & listeners

## Widgets

- `Grid(gridDelegate:, children:)` / `Grid.count(crossAxisCount:, ...)` / `Grid.extent(maxCrossAxisExtent:, ...)` — `GridView` API without viewport; any `SliverGridDelegate`; all ctors take `direction:` + `padding:`. Drop-in for `GridView(shrinkWrap: true)` inside `ListView`/`Column` (intrinsics/dry layout work; use real `GridView` only when grid itself scrolls). `.count`/`.extent` throw `ArgumentError` on non-positive count/ratio/max extent or negative/non-finite spacing/`mainAxisExtent`. Bounded overflow clips and shows striped indicator in debug.
- `TickerBuilder(builder: (context, Duration elapsed) => ..., onTick:)` — rebuilds per frame, `elapsed` excludes paused time; `onTick` for per-frame side effects; `enabled: false` pauses frames & freezes `elapsed` (stop finished countdowns). Don't wrap in `AnimatedBuilder`.
- `ScrollTrackingExpandable(isExpanded:, child:, duration:, curve:, scrollOffset:)` — keeps growing bottom edge visible in nearest `Scrollable`; collapse never scrolls; collapsed child is offstage (unfocusable, out of semantics, tickers muted). Prefer over `AnimatedSize`/`ExpansionTile` low in scrollables. Negative `duration` throws `ArgumentError` on build (`const` ctor).

## Debounce / Throttle

`Debounce(Duration)`, `ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` — callable (`d(() => ...)`), throw `ArgumentError` on negative duration, expose `dispose()` and throw `StateError` if called or disposed again after dispose. Run in widget, never inside a notifier.

|Variant|Fires|
|-|-|
|`Debounce`|after calls stop (search-as-you-type, autosave)|
|`ThrottleFirst`|first call wins, drops rest (submit/nav anti rage-click)|
|`ThrottleLast`|drops intermediates, keeps last (scroll save, slider end)|
|`ThrottleLatest`|first call immediately, then latest per window end (live preview)|

## Listeners (outside widgets)

`LocaleListener`, `BrightnessListener` — for providers/services with no `BuildContext` (in widgets use `flutter_hooks`' `useOnPlatformBrightnessChange`; no locale hook exists -> `WidgetsBindingObserver`). Self-register on construction like `AppLifecycleListener`; `dispose()` stops (second `dispose()` throws `StateError`). Seed from platform dispatcher:

```dart
final locales = ValueNotifier<List<Locale>?>(
  WidgetsBinding.instance.platformDispatcher.locales,
);
final listener = LocaleListener((next) => locales.value = next);
// Riverpod: `state = next` in build(), ref.onDispose(listener.dispose).
```
