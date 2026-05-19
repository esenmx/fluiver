---
name: fluiver
description: fluiver utility package — widgets, reactive, observers, predicates, scope function, static helpers.
paths:
  - "**/lib/**/*.dart"
  - "**/test/**/*.dart"
---

# fluiver

**SDK gap-fillers for Flutter** — every API is something `dart:core` / Flutter SDK should ship and doesn't. With `fluiver: ^3.0.0` in pubspec, `import 'package:fluiver/fluiver.dart';` and reach for these instead of reinventing `dart:core` / Flutter SDK omissions.

> 3.0 hard break: shortcut extensions on `BuildContext`, `TextStyle`, `EdgeInsets`, `BorderRadius`, `bool`, `String`, `Key`, Flutter enums, and `DateTime.addX` are **removed**. See CHANGELOG.

## Widgets

### `FlexGrid` — non-scrolling grid

Custom `MultiChildRenderObjectWidget`, sizes to fit. Drop-in for `GridView(shrinkWrap: true)` inside `ListView` / `SingleChildScrollView` — no scroll, no perf footgun.

```dart
FlexGrid(
  crossAxisCount: 3,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  childAspectRatio: 1.0, // optional
  padding: .all(16),     // optional
  direction: .vertical,  // optional
  children: products.map(ProductCard.new).toList(),
)
```

Use `GridView` when the grid itself scrolls (viewport recycling matters).

### `PaddedFlex` / `PaddedRow` / `PaddedColumn`

`Padding` + `Flex` composition. Two render objects; a custom RenderObject would re-implement all of Flex's main/cross/baseline logic for marginal perf — not worth it.

```dart
PaddedColumn(padding: const .all(12), spacing: 6, children: [Text(title), Text(subtitle)])
PaddedRow(padding: const .symmetric(horizontal: 16), children: [...])
```

`textDirection` / `textBaseline` default `null` — `Flex` resolves from ambient `Directionality`. Don't hard-code LTR.

### `TickerBuilder`

Rebuilds every frame, exposes elapsed `Duration` since first frame. Owns its `Ticker` (start in `initState`, stop in `dispose`). Don't wrap in `AnimatedBuilder` — already per-frame.

```dart
TickerBuilder(
  builder: (context, elapsed) => Text('${elapsed.inSeconds}s'),
  onTick: (elapsed) => /* side-effect */,
)
```

## Reactive — stateful, instantiate once, dispose on teardown

```dart
final debounce = Debounce(const Duration(milliseconds: 300));
debounce(() => search(query));   // latest call wins after delay

ThrottleFirst(d);   // emit first per window, drop rest
ThrottleLast(d);    // wait, emit latest seen
ThrottleLatest(d);  // emit first + queue latest for next window
```

|Pick|When|
|--|--|
|`Debounce`|search-as-you-type, autosave — wait for user to stop|
|`ThrottleFirst`|submit / nav — first click wins, swallow rage-clicks|
|`ThrottleLast`|scroll save, slider end — discard intermediate, keep last|
|`ThrottleLatest`|live preview — rate-limit but every call matters|

All four expose `void dispose()`. Call from `State.dispose` / `ref.onDispose`. Cluster many disposers in [`DisposableBag`](#helpers).

## Observers — framework-agnostic `WidgetsBindingObserver` wrappers

Construct, `addObserver`, `removeObserver` on teardown. Works from `StatefulWidget`, `ValueNotifier`, Riverpod, BLoC, anything.

```dart
class _MyAppState extends State<MyApp> {
  late final _observer = LocaleObserver((locales) { /* react */ });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(_observer);
  }
}
```

Same shape: `BrightnessObserver((Brightness b) => ...)`, `AppLifecycleObserver((AppLifecycleState s) => ...)`.

## DateTime — predicates + merge (no arithmetic)

```dart
dt.isToday;          // local-time, DST-safe calendar shift
dt.isTomorrow;
dt.isYesterday;
dt.inThisYear;
dt.isWithinFromNow(const Duration(minutes: 5));
dt.age();            // years; handles month/day boundary

dt.truncateTime();                                      // → midnight
dt.withTimeOfDay(const TimeOfDay(hour: 9, minute: 0));
dt.toTimeOfDay();                                       // → TimeOfDay
```

Arithmetic via stdlib: `dt.add(const Duration(days: N))`. **No `addDays/Months/Years` — removed.**

## TimeOfDay

```dart
const TimeOfDay(hour: 9).onDate(.now());       // today 09:00
const TimeOfDay(hour: 9).onDate(meeting.day);  // any date 09:00
```

`onDate(date)` takes the calendar day explicitly — no hidden `DateTime.now()`, deterministic in tests.

## Enum

```dart
enum Priority with EnumIndexComparable { low, medium, high }
// gives <, <=, >, >=, compareTo by index — sortable free.

Priority.values.byNameOrNull('low');                    // Priority?
Priority.values.byNameOrElse('x', orElse: () => .low);  // Priority
```

Stdlib only ships throwing `byName`. Reach for these on untrusted input (URL, env, JSON).

## Iterable

```dart
[Child(), Child(), Child()].separated((i) => const Divider())
// → [Child(), Divider(), Child(), Divider(), Child()]
```

Builder arg is the **separator** index (0 between first two), not child index.

## Map — predicates the SDK only has on `Iterable`

```dart
map.any((k, v) => v.isActive);
map.every((k, v) => v > 0);
map.firstWhereOrNull((k, v) => v == target);   // MapEntry?
map.where((k, v) => v != null);                // Map<K, V>
map.whereKeyType<String>();                    // Map<String, V>
map.whereValueType<int>();                     // Map<K, int>
map.entryOf(key);                              // MapEntry? — null only if key absent
```

`entryOf` distinguishes "present with null value" from "absent": `{'a': null}.entryOf('a')` is `MapEntry('a', null)`, not `null`.

## Object — `.let` scope function

Bounded `T extends Object` (non-null receivers). Use `?.let(...)` for null-aware. Annotated `@useResult` — return value is the point.

```dart
// 1. Null-aware transform — value, not side-effect
final port = env['PORT']?.let(int.parse);
final user = jsonResponse?.let(User.fromJson);

// 2. Inline widget from nullable via tear-off
Column(children: [
  Text(title),
  ?subtitle?.let(Text.new),
  ?avatarUrl?.let(NetworkImage.new)?.let(_circle),
]);

// 3. Chain pure transforms without temp vars
final hash = userId.toString().let(FastHash.fnv1a);
final slug = title.trim().toLowerCase().let(_sluggify);

// 4. Conditional spread into children
Column(children: [
  Text(title),
  ...?subtitle?.let((s) => [const SizedBox(height: 4), Text(s)]),
]);

// 5. Static method as transform — no lambda
final id = rawId?.let(int.tryParse);
final dur = millis?.let(Duration.new);
```

**Don't use `.let` for:**

- side-effect-only calls — return value wasted, use `if (x != null) { foo(x); }`
- multi-line bodies — temp variable reads better
- chains beyond three — name the steps

## Helpers

### `FastHash.fnv1a(String)` — VM only

FNV-1a 64-bit, stable across runs/Dart versions. For hash-map keys, cache shards, dedup. **NOT cryptographic. NOT web-safe** (JS 53-bit int limit corrupts math).

```dart
final h = FastHash.fnv1a('input');
```

### `NetworkProbe.hasConnection({Duration timeout})`

TCP probe to Cloudflare DNS `1.0.0.1:53`. Skips DNS resolution. `false` on `SocketException` / `TimeoutException`; other errors propagate. Web short-circuits to `true` (no `dart:io`).

```dart
if (await NetworkProbe.hasConnection()) { /* online */ }
```

### `TextFieldBuilders.disabledCounter`

Hides `TextField`'s character counter.

```dart
TextField(buildCounter: TextFieldBuilders.disabledCounter)
```

### `platformDispatch<T>(...)` — top-level

```dart
final padding = platformDispatch<EdgeInsets>(
  android: () => const .all(8),
  ios: () => const .all(16),
  web: () => .zero,
);
```

Throws `UnsupportedError` if current platform has no callback — opt in to what you support.

### `LRUCache<K, V>(maxEntries: N)`

Bounded LRU. Reads/writes promote to most-recent; O(1). Not thread-safe; per-isolate.

```dart
final cache = LRUCache<String, User>(maxEntries: 100)..['alice'] = user;
final hit = cache['alice'];   // promotes
cache.remove('alice');
cache.clear();
```

### `DisposableBag`

Collects `dispose` / `cancel` / `close` closures; one call flushes all in registration order. `dispose()` is idempotent; adding after dispose runs the closure immediately.

```dart
final bag = DisposableBag()
  ..add(debounce.dispose)
  ..add(subscription.cancel)
  ..add(controller.dispose);
await bag.dispose();
```
