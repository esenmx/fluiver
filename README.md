# fluiver

[![pub](https://img.shields.io/pub/v/fluiver.svg)](https://pub.dev/packages/fluiver)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Agent-friendly SDK gap-fillers for Flutter.** Tight surface, ships an
LLM skill — agents reach for fluiver instead of reinventing each helper.

```yaml
dependencies:
  fluiver: ^4.0.0
```

> No overlap with `package:collection`, `package:async`, `flutter_hooks`,
> or other official dart-lang / flutter packages.

---

## Install

```bash
dart pub add fluiver
```

```dart
import 'package:fluiver/fluiver.dart';
```

---

## LLM skill

Ships a description-triggered skill at
[`skills/flutter-fluiver/SKILL.md`](skills/flutter-fluiver/SKILL.md)
so agents reach for fluiver APIs instead of hand-rolling
`firstWhere(... orElse: ...)`, `controller.text =` caret-resets, or yet another
`Debouncer`. Vendor it into your agent's skills directory — installing it is the
consumer's call.

---

## Highlights

Ordered by everyday reach — the SDK gap-fillers up top get hit on most
files; the niche helpers further down get hit when you actually need
them.

### `Object.let` — Kotlin scope function

Bounded to `T extends Object` so it doesn't pollute autocomplete on
nullables. Use `?.let(...)` for null-aware chaining.

```dart
// Null-aware transform — returns a value, not a side-effect
final port = env['PORT']?.let(int.parse);
final user = jsonResponse?.let(User.fromJson);

// Inline widget construction via tear-off
Column(children: [
  Text(title),
  ?subtitle?.let(Text.new),
  ?avatarUrl?.let(NetworkImage.new),
]);

// Chain pure transforms without temp vars
final hash = userId.toString().let(FastHash.fnv1a);
final slug = title.trim().toLowerCase().let(_sluggify);
```

Skip `.let` for side-effect-only calls, multi-line bodies, or chains
beyond three.

### Iterable / Map / Enum gap-fillers

```dart
// Enum — non-throwing lookup, no asNameMap() allocation
MyEnum.values.byNameOrNull('x') ?? .bar;

// Map — filters that return a Map, not an entry iterable
map.where((k, v) => v != null);
map.whereKeyType<String>();
map.whereValueType<int>();
map.entryOf(key); // null only when key absent

// Iterable
list.separated((i) => const Divider());
[1, 2, 3, 4, 5].windowed(3); // ([1,2,3], [2,3,4], [3,4,5])
```

### DateTime predicates

```dart
dt.isToday;
dt.isTomorrow;
dt.isYesterday;
dt.inThisYear;
dt.isWithinFromNow(const Duration(minutes: 5));
birthDate.age();

dt.truncateTime();                                 // → midnight
dt.withTimeOfDay(const TimeOfDay(hour: 9));
```

Arithmetic stays on stdlib: `dt.add(const Duration(days: 7))`.

### TimeOfDay

```dart
const TimeOfDay(hour: 9).onDate(DateTime.now());   // today 09:00
const TimeOfDay(hour: 9).onDate(meeting.day);      // any date 09:00
```

`onDate(date)` takes the calendar day explicitly — no hidden
`DateTime.now()`, deterministic in tests.

### `Future.timeoutOrNull`

```dart
final user = await fetchUser().timeoutOrNull(const Duration(seconds: 2));
if (user == null) {
  showRetry();
}
```

Only timeout becomes `null`; errors from the underlying future still
propagate.

### Listeners

For widget context use the matching `flutter_hooks` hook
(`useOnPlatformBrightnessChange`). These wrappers fill the gap for
providers — non-widget code that holds a device-state listenable. Named
`*Listener` to match the framework's `AppLifecycleListener`.

```dart
@riverpod
class LocalesNotifier extends _$LocalesNotifier {
  @override
  List<Locale>? build() {
    final listener = LocaleListener((locales) => state = locales);
    WidgetsBinding.instance.addObserver(listener);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(listener));
    return PlatformDispatcher.instance.locales;
  }
}
```

Same shape for `BrightnessListener`. App lifecycle needs no wrapper —
the framework's `AppLifecycleListener` already is one.

### Color — HSL transforms

```dart
final pressed = Theme.of(context).colorScheme.primary.darken();
final hover = Theme.of(context).colorScheme.primary.lighten();

Container(
  color: tagColor,
  child: Text(label, style: TextStyle(color: tagColor.contrastText)),
);
```

### ScrollController — position + edge animation

```dart
final controller = ScrollController();
controller.atTop;        // false when no client attached, then true at top
controller.atBottom;
await controller.animateToBottom();                // 250ms easeOut by default
await controller.animateToTop(duration: const Duration(milliseconds: 400));
```

### TextEditingController — caret-preserving replace

```dart
controller.setTextAndCaret('hello');            // caret at end
controller.setTextAndCaret('hello', caret: 0);  // caret at start
```

Setting `controller.text = ...` directly resets the caret to `0` — this
puts it where you asked instead.

### `Grid` — non-scrolling grid

`GridView`'s layout without its viewport — configured by the same
`SliverGridDelegate` family, with `Grid.count` / `Grid.extent` mirroring
`GridView.count` / `GridView.extent` 1:1. The drop-in for
`GridView(shrinkWrap: true)` inside `ListView` /
`SingleChildScrollView`: no repaint boundaries, no scroll semantics, and
intrinsics/dry layout actually work (a shrink-wrapped `GridView` throws
inside `IntrinsicHeight`).

```dart
ListView(children: [
  const Text('Featured'),
  Grid.count(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    children: products.map(ProductCard.new).toList(),
  ),
]);
```

Use `GridView` when the grid itself scrolls (viewport recycling
matters).

### `TickerBuilder`

Rebuilds every frame, exposes elapsed `Duration` since first frame.

```dart
TickerBuilder(
  builder: (context, elapsed) => Text('${elapsed.inSeconds}s'),
);
```

### `ScrollTrackingExpandable`

Expand/collapse with a size animation that keeps the growing bottom
edge visible in the nearest `Scrollable` — an expanding tile near the
bottom of a list no longer overflows below the fold.

```dart
ScrollTrackingExpandable(
  isExpanded: showDetails,
  scrollOffset: 16, // extra breathing room below the bottom edge
  child: const DetailsCard(),
);
```

Collapse never scrolls; only expansion tracks.

### Debounce / Throttle

```dart
final debounce = Debounce(const Duration(milliseconds: 300));

TextField(
  onChanged: (q) => debounce(() => search(q)),
);
```

`ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` cover the rate-limit
variants. All four expose `dispose()`.

### `LRUCache` / `DisposableBag`

```dart
final cache = LRUCache<String, User>(maxEntries: 100);
cache[user.id] = user;
final hit = cache[user.id];                        // promotes to most-recent
final user = cache.putIfAbsent(id, () => loadUser(id)); // lazy on miss

final bag = DisposableBag()
  ..add(debounce.dispose)
  ..addAll([subscription.cancel, controller.dispose]);
await bag.dispose();
```

Async disposers start in registration order but are awaited together;
dependent steps (flush, then close) go in one closure.

### Static helpers

```dart
if (await NetworkProbe.checkConnection()) { /* online */ }

final h = FastHash.fnv1a('input'); // FNV-1a 64-bit (throws on JS web; VM/Wasm fine)

final storeUrlString = platformDispatch<String>(
  android: () => 'https://play.google.com/store/apps/details?id=com.example.app',
  ios: () => 'https://apps.apple.com/app/id123456789',
);

TextField(buildCounter: TextFieldBuilders.disabledCounter);
```

---

## Name

**flu**tter + [**quiver**](https://github.com/google/quiver-dart) — same
spirit as Google's archived Dart utility library, scoped to what Flutter
apps need today.

---

## License

MIT.
