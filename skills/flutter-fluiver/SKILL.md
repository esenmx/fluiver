---
name: flutter-fluiver
description: SDK gap-fillers via package:fluiver — use instead of reinventing. Grid (non-scroll grid, GridView API), TickerBuilder, ScrollTrackingExpandable (expand/collapse pinned into view), Debounce/Throttle*, Locale/Brightness listeners, DateTime/TimeOfDay predicates, Enum.byNameOrNull, Iterable separated/windowed, Map.entryOf, Object.let, Color darken/lighten/contrastText, ScrollController atTop/animateTo*, Future.timeoutOrNull, TextEditingController.setTextAndCaret, FastHash, NetworkProbe, platformDispatch, LRUCache, DisposableBag.
---

# flutter-fluiver

`import 'package:fluiver/fluiver.dart';` — APIs the Flutter SDK is missing. Reach for these instead of hand-rolling. **No overlap with `package:collection` / `package:async` / `flutter_hooks`** — prefer those first.

## Widgets

- `Grid(gridDelegate:, children:)` / `Grid.count(crossAxisCount:, ...)` / `Grid.extent(maxCrossAxisExtent:, ...)` — GridView's API minus the viewport; any `SliverGridDelegate`. All ctors also take `direction:` (main axis) and `padding:`. Drop-in for `GridView(shrinkWrap: true)` inside a `ListView` / `Column`; unlike that, intrinsics/dry layout work. Real `GridView` only when the grid itself scrolls.
- `TickerBuilder(builder: (context, Duration elapsed) => …, onTick:)` — rebuilds per frame, `elapsed` since first frame; `onTick` for per-frame side effects. Don't wrap in `AnimatedBuilder`.
- `ScrollTrackingExpandable(isExpanded:, child:, duration:, curve:, scrollOffset:)` — expand/collapse that keeps the growing bottom edge visible in the nearest `Scrollable`. Collapse never scrolls. Use over `AnimatedSize`/`ExpansionTile` for tiles low in a scrollable.

## Debounce / Throttle

`Debounce(Duration)`, `ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` — callable (`d(() => …)`), all expose `dispose()`. Run in the widget, never inside a notifier.

|Variant|Fires|
|--|--|
|`Debounce`|after calls stop (search-as-you-type, autosave)|
|`ThrottleFirst`|first call wins, swallow the rest (submit / nav — anti rage-click)|
|`ThrottleLast`|drops intermediates, keeps the last (scroll save, slider end)|
|`ThrottleLatest`|rate-limited but every call eventually fires (live preview)|

## Listeners (device state outside a widget)

`LocaleListener`, `BrightnessListener` — for providers/services with no `BuildContext` (in widgets, use the matching `flutter_hooks` hook). Seed from `PlatformDispatcher.instance`:

```dart
final listener = LocaleListener((locales) => state = locales);
WidgetsBinding.instance.addObserver(listener);
ref.onDispose(() => WidgetsBinding.instance.removeObserver(listener));
```

## Extensions

- **DateTime predicates**: `isToday`, `isTomorrow`, `isYesterday`, `inThisYear`, `isWithinFromNow(Duration)`, `age()` (timezone-safe years, month/day-correct), `truncateTime()` (→ midnight, keeps UTC flag), `withTimeOfDay(TimeOfDay)`. No arithmetic helpers — stdlib `Duration`.
- **TimeOfDay**: `tod.onDate(date)` → `DateTime` on that calendar day. Day passed explicitly — deterministic in tests.
- **Enum**: `with EnumIndexComparable<MyEnum>` adds `<`/`>`/`compareTo` by index type-safely. `values.byNameOrNull(name)` → nullable, for untrusted input (stdlib `byName` throws); chain `?? .fallback`.
- **Iterable**: `separated((i) => sep)` (interleave by index slot); `windowed(size, {step})` — sliding window, **drops the partial trailing window** (vs non-overlapping `collection.slices`).
- **Map**: `where` over `(k, v)`; `whereKeyType<T>()`, `whereValueType<T>()` (narrowed static type); `entryOf(key)` → `MapEntry?`, null **only when the key is absent** (present-with-null ≠ missing).
- **Object.let** (`T extends Object`): transform-and-return; `?.let(...)` for null-aware (`env['PORT']?.let(int.parse)`). Skip for side-effect-only calls, multi-line bodies, chains beyond three.
- **Color** (HSL): `darken([amount])`, `lighten([amount])` (default ±0.1), `contrastText` (black/white by luminance).
- **ScrollController**: `atTop`, `atBottom`, `animateToTop({duration, curve})`, `animateToBottom(...)` — `hasClients`-safe no-ops when unattached.
- **Future**: `timeoutOrNull(Duration)` → `Future<T?>` — null on timeout **only**; underlying errors still throw.
- **TextEditingController**: `setTextAndCaret(text, {caret})` — text + caret in one shot (`.text =` resets caret to 0).

## Helpers

|API|Note|
|--|--|
|`FastHash.fnv1a(String)` → `int`|FNV-1a 64-bit. **Throws on JS web**; VM/Wasm fine. NOT cryptographic.|
|`NetworkProbe.checkConnection({host, port, timeout})`|`false` on `SocketException`/`TimeoutException`; web → `true`. Defaults `1.0.0.1:53`, 3s; `host` = literal IP.|
|`platformDispatch<T>({android, ios, macos, web, …})`|Per-platform value (all params lowercase); throws `UnsupportedError` on platforms without a callback.|
|`TextFieldBuilders.disabledCounter`|`TextField(buildCounter: TextFieldBuilders.disabledCounter)` hides the counter.|
|`LRUCache<K, V>(maxEntries:)`|O(1) get/put, promotes to MRU; per-isolate. For async, type `LRUCache<K, Future<V>>` so concurrent misses dedupe.|
|`DisposableBag()`|`..add(fn)` / `..addAll([...])`; idempotent `dispose()` runs all, then throws `DisposableBagException` if any failed; async disposers start in registration order but are awaited together — dependent steps (flush, then close) go in one closure. Pair with `ref.onDispose(bag.dispose)`.|
