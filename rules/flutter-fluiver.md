---
name: flutter-fluiver
description: fluiver utility package APIs.
paths:
  - "**/lib/**/*.dart"
  - "**/test/**/*.dart"
---

# flutter-fluiver

**SDK gap-fillers for Flutter.** Every API is something `dart:core` / Flutter SDK should ship and doesn't. `import 'package:fluiver/fluiver.dart';` and reach for these instead of reinventing.

> **Don't reinvent these (covered elsewhere).** `List.swap` lives in `package:collection`; `Random.intInRange` / `Random.pick` in `package:rand`; `useAutomaticKeepAlive` / `useOnAppLifecycleStateChange` / `useOnPlatformBrightnessChange` in `flutter_hooks`. fluiver does not duplicate them.

## Widgets

### `FlexGrid` — non-scrolling grid

Drop-in for `GridView(shrinkWrap: true)` inside `ListView` / `SingleChildScrollView` — no scroll, no perf footgun.

```dart
FlexGrid(
  crossAxisCount: 3,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  childAspectRatio: 1.0, // optional
  padding: .all(16), // optional
  direction: .vertical, // optional
  children: products.map(ProductCard.new).toList(),
)
```

Use `GridView` when the grid itself scrolls (viewport recycling matters).

### `TickerBuilder`

Rebuilds every frame, exposes elapsed `Duration` since first frame. Don't wrap in `AnimatedBuilder` — already per-frame.

```dart
TickerBuilder(
  builder: (context, elapsed) => Text('${elapsed.inSeconds}s'),
  onTick: (elapsed) => /* side-effect */,
)
```

## Reactive — stateful, instantiate once, dispose on teardown

```dart
final debounce = Debounce(const Duration(milliseconds: 300));
debounce(() => search(query));

ThrottleFirst(d);
ThrottleLast(d);
ThrottleLatest(d);
```

|Pick|When|
|--|--|
|`Debounce`|search-as-you-type, autosave — wait for user to stop|
|`ThrottleFirst`|submit / nav — first click wins, swallow rage-clicks|
|`ThrottleLast`|scroll save, slider end — discard intermediate, keep last|
|`ThrottleLatest`|live preview — rate-limit but every call matters|

All four expose `void dispose()`. Call from `State.dispose` / `ref.onDispose`. Cluster many disposers in [`DisposableBag`](#helpers).

## Observers

For widget context use the matching `flutter_hooks` hook (`useOnAppLifecycleStateChange`, `useOnPlatformBrightnessChange`). These observer wrappers fill the gap in non-widget code — providers that hold a device-state listenable.

```dart
@riverpod
class LocalesNotifier extends _$LocalesNotifier {
  @override
  List<Locale>? build() {
    final observer = LocaleObserver((locales) => state = locales);
    WidgetsBinding.instance.addObserver(observer);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
    return PlatformDispatcher.instance.locales;
  }
}
```

Same shape: `BrightnessObserver((Brightness b) => ...)` seeded with `PlatformDispatcher.instance.platformBrightness`; `AppLifecycleObserver((AppLifecycleState s) => ...)` seeded with `WidgetsBinding.instance.lifecycleState`.

## DateTime — predicates + merge (no arithmetic)

```dart
dt.isToday; // local-time, DST-safe calendar shift
dt.isTomorrow;
dt.isYesterday;
dt.inThisYear;
dt.isWithinFromNow(const Duration(minutes: 5));
dt.age(); // years; handles month/day boundary

dt.truncateTime(); // → midnight
dt.withTimeOfDay(const TimeOfDay(hour: 9, minute: 0));
dt.toTimeOfDay(); // → TimeOfDay
```

Arithmetic via stdlib: `dt.add(const Duration(days: N))`. **No `addDays/Months/Years` — use `Duration` arithmetic.**

## TimeOfDay

```dart
const TimeOfDay(hour: 9).onDate(.now()); // today 09:00
const TimeOfDay(hour: 9).onDate(meeting.day); // any date 09:00
```

`onDate(date)` takes the calendar day explicitly — no hidden `DateTime.now()`, deterministic in tests.

## Enum

```dart
enum Priority with EnumIndexComparable { low, medium, high }
// gives <, <=, >, >=, compareTo by index — sortable free.

Priority.values.byNameOrNull('low'); // Priority?
Priority.values.byNameOrNull('x') ?? .low; // fallback via shorthand
```

Stdlib only ships throwing `byName`. Reach for `byNameOrNull` on untrusted input (URL, env, JSON); chain `??` for the fallback case.

## Iterable

```dart
[Child(), Child(), Child()].separated((i) => const Divider())
// → [Child(), Divider(), Child(), Divider(), Child()]

[1, 2, 3, 4, 5].windowed(3); // ([1,2,3], [2,3,4], [3,4,5])
[1, 2, 3, 4, 5].windowed(2, step: 2); // ([1,2], [3,4])
[1, 2].windowed(3); // () — size > length, empty
```

`separated` — arg is separator index (0 between first two), not child index. `windowed` — stepped sliding window (vs `package:collection.slices`, non-overlapping); partial trailing window dropped, matches Kotlin's `partialWindows: false`.

## Map — predicates the SDK only has on `Iterable`

```dart
map.any((k, v) => v.isActive);
map.every((k, v) => v > 0);
map.firstWhereOrNull((k, v) => v == target); // MapEntry?
map.where((k, v) => v != null); // Map<K, V>
map.whereKeyType<String>(); // Map<String, V>
map.whereValueType<int>(); // Map<K, int>
map.entryOf(key); // MapEntry? — null only if key absent
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
```

**Don't use `.let` for:**

- side-effect-only calls — return value wasted, use `if (x != null) { foo(x); }`
- multi-line bodies — temp variable reads better
- chains beyond three — name the steps

## Color — HSL transforms

```dart
final pressed = Theme.of(context).colorScheme.primary.darken(); // -.1 lightness
final hover = Theme.of(context).colorScheme.primary.lighten(.2); // +.2 lightness
final fg = bg.contrastText; // black or white via Color.computeLuminance()
```

`darken` / `lighten` go through `HSLColor`; `amount` clamped to `[0, 1]`. Result lightness clamped to `[0, 1]`. `contrastText` picks `Colors.black` or `Colors.white` based on luminance.

## ScrollController — position + edge animation

```dart
controller.atTop; // false when no client attached, true at minScrollExtent
controller.atBottom;
await controller.animateToTop();
await controller.animateToBottom(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeInOut,
);
```

Defaults: `Duration(milliseconds: 250)` / `Curves.easeOut`. All four methods are `hasClients`-safe — no-op or `false` when nothing's attached yet.

## Future — null on timeout

```dart
final user = await fetchUser().timeoutOrNull(const Duration(seconds: 2));
if (user == null) {
  showRetry();
}
```

Only timeout becomes `null`; errors from the underlying future still throw. Use in place of try/catch around `.timeout()`.

## TextEditingController — caret-preserving text replace

```dart
controller.setTextAndCaret('hello'); // caret at 5 (end)
controller.setTextAndCaret('hello', caret: 0); // caret at start
```

`controller.text = ...` resets the caret to `0` — well-known papercut. This sets `.value` in one shot so the caret lands where you ask (defaults to end).

## Helpers

### `FastHash.fnv1a(String)` — VM only

FNV-1a 64-bit, stable across runs/Dart versions. For hash-map keys, cache shards, dedup. **NOT cryptographic. NOT web-safe** (JS 53-bit int limit corrupts math).

```dart
final h = FastHash.fnv1a('input');
```

### `NetworkProbe.hasConnection({Duration timeout})`

`false` on `SocketException` / `TimeoutException`; other errors propagate. Web short-circuits to `true` (no `dart:io`).

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
final storeUrl = platformDispatch<Uri>(
  android: () => 'https://play.google.com/store/apps/details?id=com.example.app',
  ios: () => 'https://apps.apple.com/app/id123456789',
);
await launchUrl(storeUrl);
```

Throws `UnsupportedError` if current platform has no callback — opt in to what you support.

### `LRUCache<K, V>(maxEntries: N)`

Bounded LRU. Reads/writes promote to most-recent; O(1). Not thread-safe; per-isolate.

```dart
final cache = LRUCache<String, User>(maxEntries: 100)..['alice'] = user;
final hit = cache['alice']; // promotes
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
