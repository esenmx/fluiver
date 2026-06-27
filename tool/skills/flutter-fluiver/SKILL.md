---
name: flutter-fluiver
description: SDK gap-fillers via package:fluiver — use instead of reinventing. FlexGrid (non-scroll grid), TickerBuilder, Debounce/Throttle*, Locale/Brightness/AppLifecycle observers, DateTime/TimeOfDay predicates, Enum.byNameOrNull, Iterable separated/windowed, Map.entryOf, Object.let, Color darken/lighten/contrastText, ScrollController atTop/animateTo*, Future.timeoutOrNull, TextEditingController.setTextAndCaret, FastHash, NetworkProbe, platformDispatch, LRUCache, DisposableBag.
---

# flutter-fluiver

`import 'package:fluiver/fluiver.dart';` — APIs the Flutter SDK is missing. Reach for these instead of hand-rolling. **No overlap with `package:collection` / `package:async` / `flutter_hooks`** — prefer those first.

## Widgets

- `FlexGrid(crossAxisCount:, mainAxisSpacing:, crossAxisSpacing:, children:)` — non-scrolling grid (custom `RenderObject`). The drop-in for `GridView(shrinkWrap: true)` inside a `ListView` / `SingleChildScrollView`; use a real `GridView` only when the grid itself scrolls (viewport recycling).
- `TickerBuilder(builder: (context, Duration elapsed) => …)` — rebuilds per frame, `elapsed` since first frame. Don't wrap in `AnimatedBuilder`.

## Debounce / Throttle

`Debounce(Duration)`, `ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` — all callable (`d(() => …)`) and all expose `dispose()` (call from `State.dispose` / `ref.onDispose`, or cluster in a `DisposableBag`). Run them in the widget, never inside a notifier.

|Variant|Fires|
|--|--|
|`Debounce`|after calls stop (search-as-you-type, autosave)|
|`ThrottleFirst`|first call wins, swallow the rest (submit / nav — anti rage-click)|
|`ThrottleLast`|drops intermediates, keeps the last (scroll save, slider end)|
|`ThrottleLatest`|rate-limited but every call eventually fires (live preview)|

## Observers (device state outside a widget)

`LocaleObserver`, `BrightnessObserver`, `AppLifecycleObserver` — for providers/services that need device state where there's no `BuildContext` (in widgets, use the matching `flutter_hooks` hook instead). Seed from `PlatformDispatcher.instance` / `WidgetsBinding.instance`, register with `addObserver`, remove in `onDispose`:

```dart
final observer = LocaleObserver((locales) => state = locales);
WidgetsBinding.instance.addObserver(observer);
ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
```

## Extensions

- **DateTime predicates**: `isToday`, `isTomorrow`, `isYesterday`, `inThisYear`, `isWithinFromNow(Duration)`, `age()` (timezone-safe years, month/day-correct), `truncateTime()` (→ midnight), `withTimeOfDay(TimeOfDay)`, `toTimeOfDay()`. No arithmetic helpers — use stdlib `Duration` (there is no `addDays/Months/Years`).
- **TimeOfDay**: `tod.onDate(date)` → `DateTime` on that calendar day (preserves UTC/local alignment). Day passed explicitly (no hidden `DateTime.now()` → deterministic in tests).
- **Enum**: `with EnumIndexComparable<MyEnum>` adds `<`/`>`/`compareTo` by index type-safely. `Values.byNameOrNull(name)` → nullable — use on untrusted URL/env/JSON input (stdlib `byName` throws); chain `?? .fallback`.
- **Iterable**: `separated((i) => sep)` (interleave by index slot); `windowed(size, {step})` — stepped sliding window that **drops the partial trailing window** (vs non-overlapping `package:collection.slices`).
- **Map**: `any` / `every` / `firstWhereOrNull` / `where` over `(k, v)`; `whereKeyType<T>()`, `whereValueType<T>()`; `entryOf(key)` → `MapEntry?` that is null **only when the key is absent** (distinguishes present-with-null from missing).
- **Object.let** (`T extends Object`): transform-and-return; `?.let(...)` for null-aware (`env['PORT']?.let(int.parse)`, `?url?.let(NetworkImage.new)`). Skip it for side-effect-only calls, multi-line bodies, or chains beyond three.
- **Color** (HSL): `darken([amount])`, `lighten([amount])` (default ±0.1), `contrastText` (black or white by luminance). `amount` and result lightness clamp to `[0,1]`.
- **ScrollController**: `atTop`, `atBottom`, `animateToTop({duration, curve})`, `animateToBottom(...)` — all `hasClients`-safe (no-op when unattached); defaults 250 ms `easeOut`.
- **Future**: `timeoutOrNull(Duration)` → `Future<T?>` — null on timeout **only**; the underlying future's errors still throw.
- **TextEditingController**: `setTextAndCaret(text, {caret})` — text + caret in one shot. Plain `controller.text = …` resets the caret to 0 (papercut).

## Helpers

|API|Note|
|--|--|
|`FastHash.fnv1a(String)` → `int`|FNV-1a 64-bit. **VM only** — JS 53-bit ints corrupt it. NOT cryptographic.|
|`NetworkProbe.hasConnection({timeout})`|`false` on `SocketException` / `TimeoutException`; web short-circuits to `true`.|
|`platformDispatch<T>({android, ios, macos, …})`|Per-platform value; **throws `UnsupportedError`** when the current platform has no callback — opt in explicitly.|
|`TextFieldBuilders.disabledCounter`|`TextField(buildCounter: TextFieldBuilders.disabledCounter)` hides the counter.|
|`LRUCache<K, V>(maxEntries:)`|O(1) get/put, promotes to MRU; per-isolate. `putIfAbsent(k, ifAbsent)` lazy on miss. For async, type `LRUCache<K, Future<V>>` so concurrent misses dedupe.|
|`DisposableBag()`|`..add(fn)` / `..addAll([...])`; idempotent `dispose()` (runs all, throws `DisposableBagException` on error). Pair with `ref.onDispose(() => unawaited(bag.dispose()))` — Riverpod doesn't await async dispose.|
