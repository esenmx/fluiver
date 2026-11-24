---
name: fluiver-usage
description: SDK gap-fillers via package:fluiver — use instead of hand-rolling. Grid, TickerBuilder, ScrollTrackingExpandable, keyboard/status-bar insets (ViewInsetsPadding, StatusBarHeader, StatusBarIcons), Debounce/Throttle*, Locale/Brightness listeners, DateTime/TimeOfDay helpers, byNameOrNull, intersperse/slidingWindows, Map.entryOf, Object.into, Color darker/lighter/contrastText, ScrollController atTop/animateTo*, timeoutOrNull, setTextAndCaret, FastHash, NetworkProbe, platformDispatch, LRUCache, DisposableBag.
---

# fluiver-usage

`import 'package:fluiver/fluiver.dart';` — Flutter/Dart SDK gap-fillers. Prefer `package:collection`, `package:async`, `flutter_hooks` first (no overlap).

## Widgets

- `Grid(gridDelegate:, children:)` / `Grid.count(crossAxisCount:, ...)` / `Grid.extent(maxCrossAxisExtent:, ...)` — `GridView` API without viewport; any `SliverGridDelegate`; all ctors take `direction:` + `padding:`. Drop-in for `GridView(shrinkWrap: true)` inside `ListView`/`Column` (intrinsics/dry layout work; use real `GridView` only when grid itself scrolls). `.count`/`.extent` throw `ArgumentError` on non-positive count/ratio/max extent or negative/non-finite spacing/`mainAxisExtent`. Bounded overflow clips and shows striped indicator in debug.
- `TickerBuilder(builder: (context, Duration elapsed) => ..., onTick:)` — rebuilds per frame, `elapsed` = running time since first frame (paused time excluded); `onTick` for per-frame side effects; `enabled: false` pauses frames & freezes `elapsed` (stop finished countdowns). Don't wrap in `AnimatedBuilder`.
- `ScrollTrackingExpandable(isExpanded:, child:)` (+ optional `duration:`, `curve:`, `scrollOffset:`) — keeps growing bottom edge visible in nearest `Scrollable`; collapse never scrolls; collapsed child is offstage (unfocusable, out of semantics, tickers muted). Prefer over `AnimatedSize`/`ExpansionTile` low in scrollables. Negative `duration` reports `ArgumentError` on build (`const` ctor).

## Insets (keyboard, status bar, home indicator)

- `ViewInsetsPadding(child:)` — pads by unconsumed keyboard insets, removes them below; never doubles (pads 0 in resizing `Scaffold` body, `Dialog`, nested). Use for: modal sheet content (`showModalBottomSheet(isScrollControlled: true, builder: (_) => ViewInsetsPadding(child: SafeArea(top: false, child: form)))` — without `isScrollControlled` the 9/16 cap hides the field, overflow reported only in debug), `Scaffold(resizeToAvoidBottomInset: false)` body, input bar in `bottomNavigationBar: ViewInsetsPadding(child: bar)` (+ `extendBody: true` to scroll behind). Not in `Scaffold.bottomSheet` of a resizing `Scaffold` (already lifted, pads twice), nor a `resizeToAvoidBottomInset: false` body above a `bottomNavigationBar` (pads bar height twice; add `extendBody: true` with `SafeArea` inside, or let it resize). `SafeArea(maintainBottomViewPadding: true)` goes inside it. `StateError` without `MediaQuery`.
- Never `Padding(bottom: MediaQuery.viewInsetsOf(context).bottom)` with the context that builds the `Scaffold` (double gap), never `viewInsets + viewPadding` (34px gap).
- `StatusBarHeader(color:, child:)` — header without `AppBar`: opaque `color` behind status bar, as wide as `child` (give full width: `Column(crossAxisAlignment: .stretch)`), `child` below status bar and side cutouts, icons contrast `color` (iOS + Android). First in a `Column` of a `Scaffold` body without `appBar`, or `SliverToBoxAdapter` first sliver (a `ListView` below it in a `Column` still pads the status bar: prefer the sliver form). `StateError` under `SafeArea`/`AppBar`/in `ListView`/modal sheet; `ArgumentError` if translucent (gradient/image: `AnnotatedRegion` + `DecoratedBox` + `SafeArea(bottom: false)`).
- `StatusBarIcons.light`/`.dark` — light/dark status icons, both platforms, = M3 `AppBar` default, nav bar untouched. Use in `AppBar(systemOverlayStyle:)` and `AnnotatedRegion(value:)` (page root without `AppBar`, hero). Not `SystemUiOverlayStyle.light/.dark` (paint Android nav bar black, light nav icons), not `statusBarIconBrightness` alone (iOS reads `statusBarBrightness`, the background).
- `AppBar` region wins over any `AnnotatedRegion` above the `Scaffold` or in its body: style via `AppBar(systemOverlayStyle:)`/`AppBarTheme`. Never `SystemChrome.setSystemUIOverlayStyle` in `build`/`initState` (overridden next frame, leaks across routes). Screen without `AppBar` and no region keeps the previous screen's icons. Transparent `AppBar` estimates dark → light icons.
- Bottom bar: `ColoredBox(color:, child: SafeArea(top: false, child: bar))`, colour outside `SafeArea` (else stops above home indicator). Content behind bar: `Scaffold(extendBody: true, bottomNavigationBar:)`, never `Stack` + `Positioned`.
- Edge-to-edge (Android 15+): `ListView(padding: x)` drops automatic safe/bar padding — use `CustomScrollView` + `SliverSafeArea(sliver: SliverPadding(padding: x, ...))` or `x + MediaQuery.paddingOf(context)` from a context below the `Scaffold`. Full-bleed hero: no `SafeArea`/`ListView` around it; `SafeArea(bottom: false)` only around its foreground.

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

## Extensions

- **DateTime**: getters `isToday`, `isTomorrow`, `isYesterday`, `inThisYear`; `isWithinFromNow(Duration)` (`ArgumentError` if negative), `age({at})` (full years from stored calendar fields, no TZ conversion; `at` defaults to local now; call `.toLocal()` on UTC-stored local dates), getter `dateOnly` (-> midnight, preserves UTC, unlike `DateUtils.dateOnly`). No arithmetic helpers; calendar days: `d.copyWith(day: d.day + n)` (keeps UTC), not `add(Duration(days: n))` (n x 24h, wall-clock hour shifts across DST); `copyWith(month: m + 1)` overflows (Jan 31 -> Mar 3).
- **TimeOfDay**: `tod.onDate(date)` -> `DateTime` on that calendar day (`package:material_ui/material_ui.dart` `TimeOfDay`). Pass day explicitly for deterministic tests.
- **Enum**: `with EnumIndexComparable<MyEnum>` adds `<`/`>`/`compareTo` by index. `values.byNameOrNull(name)` -> nullable for untrusted input (stdlib `byName` throws); chain `?? .fallback`.
- **Iterable**: `intersperse((i) => sep)` (index-aware builder, unlike `collection.separated(value)`); `slidingWindows(size, {step})` (Kotlin `windowed`; **drops partial trailing window**, vs non-overlapping `collection.slices`).
- **Map**: `where` over `(k, v)`; `whereKeyType<T>()`, `whereValueType<T>()` (narrowed static type); `entryOf(key)` -> `MapEntry?`, null **only when absent** (present-with-null != missing).
- **Object.into** (`T extends Object`, Kotlin `let`): transform-and-return; `?.into(...)` null-aware (`env['PORT']?.into(int.parse)`). Skip for side-effect-only, multi-line bodies, or chains >3.
- **Color** (HSL): `darker([amount])`, `lighter([amount])` (amount is a lightness fraction, not a percent: default 0.1; `RangeError` outside `[0, 1]`), getter `contrastText` (higher-contrast black/white). All three throw `ArgumentError` if any channel is outside `[0, 1]` (gamut-map extended sRGB first).
- **ScrollController**: getters `atTop`, `atBottom`; `animateToTop({duration, curve})`, `animateToBottom(...)` — throw `StateError` when unattached (check `hasClients`); `atTop`/`atBottom` require every attached view at edge; `animateTo*` throw `ArgumentError` unless `duration` is positive.
- **Future**: `timeoutOrNull(Duration)` -> `Future<T?>` (null on timeout **only**; underlying errors still throw; non-nullable `Future<T>` only; `ArgumentError` if negative).
- **TextEditingController**: `setTextAndCaret(text, {caret})` — sets text + valid caret whether focused or not (`.text =` sets invalid offset -1; focused fields repair to end on mobile/multiline or select-all on single-line desktop); `RangeError` if `caret` outside `0..text.length`.

## Helpers

|API|Contract|
|-|-|
|`FastHash.fnv1a(String)` -> `int`|FNV-1a-64 over UTF-16BE code units (!= UTF-8 FNV-1a). **Throws on JS web**; VM/Wasm fine. Non-cryptographic.|
|`NetworkProbe.checkConnection({host, port, timeout})`|`false` on `SocketException`/`TimeoutException`. Defaults `1.0.0.1:53`, 3s; `host` = literal IP. Negative `timeout` -> `ArgumentError`. Web -> `UnsupportedError`.|
|`NetworkProbe.isBrowserOnline()`|Web `navigator.onLine` (`false` = known offline); non-web -> `UnsupportedError`.|
|`platformDispatch<T>({android, ios, macos, web, ...})`|Per-platform value (lowercase params); throws `UnsupportedError` when current platform callback omitted.|
|`TextFieldBuilders.disabledCounter`|`TextField(buildCounter: TextFieldBuilders.disabledCounter)` hides counter.|
|`LRUCache<K, V>(maxEntries:)`|O(1) get/put, promotes to MRU; per-isolate. For async, use `LRUCache<K, Future<V>>` to dedupe concurrent misses. `peek(key)` reads without promoting; `keys`/`values`/`entries` are snapshots.|
|`DisposableBag()`|`..add(fn)`/`..addAll([...])`; `dispose()` runs all once (re-calls return same future), then throws `DisposableBagException` if any failed; `add` after settle or `dispose()` from own disposer -> `StateError`. Async disposers start in registration order and await together (put dependent steps in one closure). Pair with `ref.onDispose(bag.dispose)`.|
