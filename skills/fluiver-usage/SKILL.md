---
name: fluiver-usage
description: SDK gap-fillers via package:fluiver — use instead of reinventing. Grid (non-scroll grid, GridView API), TickerBuilder, ScrollTrackingExpandable (expand/collapse pinned into view), Debounce/Throttle*, Locale/Brightness listeners, DateTime/TimeOfDay predicates, Enum.byNameOrNull, Iterable separated/slidingWindows, Map.entryOf, Object.into, Color darken/lighten/contrastText, ScrollController atTop/animateTo*, Future.timeoutOrNull, TextEditingController.setTextAndCaret, FastHash, NetworkProbe, platformDispatch, LRUCache, DisposableBag.
---

# fluiver-usage

`import 'package:fluiver/fluiver.dart';` — APIs the Flutter SDK is missing.
Reach for these instead of hand-rolling. **No overlap with `package:collection`
/ `package:async` / `flutter_hooks`** — prefer those first.

## Widgets

- `Grid(gridDelegate:, children:)` / `Grid.count(crossAxisCount:, ...)` /
  `Grid.extent(maxCrossAxisExtent:, ...)` — GridView's API minus the viewport;
  any `SliverGridDelegate`. All ctors also take `direction:` (main axis) and
  `padding:`. Drop-in for `GridView(shrinkWrap: true)` inside a `ListView` /
  `Column`; unlike that, intrinsics/dry layout work. Real `GridView` only when
  the grid itself scrolls.
- `TickerBuilder(builder: (context, Duration elapsed) => …, onTick:)` — rebuilds
  per frame, `elapsed` = running time since first frame (paused time excluded);
  `onTick` for per-frame side effects; `enabled: false` pauses (no frames,
  `elapsed` frozen) — stop a finished countdown. Don't wrap in
  `AnimatedBuilder`.
- `ScrollTrackingExpandable(isExpanded:, child:)` (+ `duration:`, `curve:`,
  `scrollOffset:`) — expand/collapse that keeps the growing bottom edge visible
  in the nearest `Scrollable`. Collapse never scrolls; collapsed child is
  offstage (unfocusable, out of semantics, tickers muted). Use over
  `AnimatedSize`/`ExpansionTile` for tiles low in a scrollable.

## Debounce / Throttle

`Debounce(Duration)`, `ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` —
callable (`d(() => …)`), throw `ArgumentError` for a negative duration, all
expose `dispose()` and throw `StateError` if called after disposal. Run in the
widget, never inside a notifier.

| Variant | Fires |
| --- | --- |
| `Debounce` | after calls stop (search-as-you-type, autosave) |
| `ThrottleFirst` | first call wins, swallow the rest (submit / nav — anti rage-click) |
| `ThrottleLast` | drops intermediates, keeps the last (scroll save, slider end) |
| `ThrottleLatest` | first call at once, then the latest call of each window as it ends (live preview) |

## Listeners (device state outside a widget)

`LocaleListener`, `BrightnessListener` — for providers/services with no
`BuildContext` (in widgets: `flutter_hooks`' `useOnPlatformBrightnessChange`; no
locale hook exists, so mix `WidgetsBindingObserver` into the `State`). They
register themselves on construction like `AppLifecycleListener`; `dispose()`
stops them (a second `dispose()` throws `StateError`). Seed from the platform
dispatcher:

```dart
final locales = ValueNotifier<List<Locale>?>(
  WidgetsBinding.instance.platformDispatcher.locales,
);
final listener = LocaleListener((next) => locales.value = next);
// Riverpod: `state = next` in build(), ref.onDispose(listener.dispose).
```

## Extensions

- **DateTime predicates**: `isToday()`, `isTomorrow()`, `isYesterday()`,
  `inThisYear()`, `isWithinFromNow(Duration)` (throws `ArgumentError` if
  negative), `age({at})` (full years from both dates' calendar fields as stored,
  no zone conversion; `at` defaults to local now; `.toLocal()` a local date
  saved via `.toUtc()`), `truncateTime()` (→ midnight, keeps UTC flag). No
  arithmetic helpers — stdlib `Duration`.
- **TimeOfDay**: `tod.onDate(date)` → `DateTime` on that calendar day (supports
  both `package:material_ui/material_ui.dart` and
  `package:flutter/material.dart` `TimeOfDay`). Day passed explicitly —
  deterministic in tests.
- **Enum**: `with EnumIndexComparable<MyEnum>` adds `<`/`>`/`compareTo` by index
  type-safely. `values.byNameOrNull(name)` → nullable, for untrusted input
  (stdlib `byName` throws); chain `?? .fallback`.
- **Iterable**: `separated((i) => sep)` (interleave by index slot);
  `slidingWindows(size, {step})` (Kotlin's `windowed`; dartx's same-named member
  would clash), **drops the partial trailing window** (vs non-overlapping
  `collection.slices`).
- **Map**: `where` over `(k, v)`; `whereKeyType<T>()`, `whereValueType<T>()`
  (narrowed static type); `entryOf(key)` → `MapEntry?`, null **only when the key
  is absent** (present-with-null ≠ missing).
- **Object.into** (`T extends Object`, Kotlin's `let`): transform-and-return;
  `?.into(...)` for null-aware (`env['PORT']?.into(int.parse)`). Skip for
  side-effect-only calls, multi-line bodies, chains beyond three.
- **Color** (HSL): `darken([amount])`, `lighten([amount])` (default ±0.1;
  `RangeError` unless `amount` is within `[0, 1]`; `ArgumentError` when a
  channel is outside `[0, 1]` — map extended sRGB into gamut first),
  `contrastText()` (black/white with the higher contrast ratio).
- **ScrollController**: `atTop()`, `atBottom()`,
  `animateToTop({duration, curve})`, `animateToBottom(...)` — throw `StateError`
  when unattached (check `hasClients`), like `position`; `atTop()`/`atBottom()`
  true only when every attached view is at that edge.
- **Future**: `timeoutOrNull(Duration)` → `Future<T?>` — null on timeout
  **only**; underlying errors still throw. Non-nullable `Future<T>` only.
- **TextEditingController**: `setTextAndCaret(text, {caret})` — text + caret in
  one shot (`.text =` resets caret to 0); `RangeError` if `caret` is outside
  `0..text.length`.

## Helpers

| API | Note |
| --- | --- |
| `FastHash.fnv1a(String)` → `int` | FNV-1a-64 over UTF-16BE code units (≠ FNV-1a over UTF-8). **Throws on JS web**; VM/Wasm fine. NOT cryptographic. |
| `NetworkProbe.checkConnection({host, port, timeout})` | `false` on `SocketException`/`TimeoutException`. Defaults `1.0.0.1:53`, 3s; `host` = literal IP. Web → `UnsupportedError`. |
| `NetworkProbe.isBrowserOnline()` | web `navigator.onLine` (`false` = known offline); off web → `UnsupportedError`. |
| `platformDispatch<T>({android, ios, macos, web, …})` | Per-platform value (all params lowercase); throws `UnsupportedError` on platforms without a callback. |
| `TextFieldBuilders.disabledCounter` | `TextField(buildCounter: TextFieldBuilders.disabledCounter)` hides the counter. |
| `LRUCache<K, V>(maxEntries:)` | O(1) get/put, promotes to MRU; per-isolate. For async, type `LRUCache<K, Future<V>>` so concurrent misses dedupe. `peek(key)` reads without promoting; `keys`/`values`/`entries` are snapshots. |
| `DisposableBag()` | `..add(fn)` / `..addAll([...])`; `dispose()` runs all once (every call returns the same future), then throws `DisposableBagException` if any failed; `add` after it settled → `StateError`; `dispose()` from its own disposer → `StateError`; async disposers start in registration order but are awaited together — dependent steps (flush, then close) go in one closure. Pair with `ref.onDispose(bag.dispose)`. |
