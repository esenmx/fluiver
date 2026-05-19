# fluiver

[![pub](https://img.shields.io/pub/v/fluiver.svg)](https://pub.dev/packages/fluiver)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**SDK gap-fillers for Flutter.** Every API passes the gap test — the Dart or Flutter SDK should have shipped it and didn't. No shortcut sugar, no `package:collection` overlap.

- Debounce/throttle helpers with proper disposal
- `FlexGrid` — non-scrolling grid safe inside `ListView` / `SingleChildScrollView`
- `PaddedFlex` / `PaddedRow` / `PaddedColumn` — padding + flex glue widgets
- `TickerBuilder` — per-frame rebuild with elapsed `Duration`
- System observers (`Locale`, `Brightness`, `AppLifecycle`) without `WidgetsBindingObserver` boilerplate
- `DateTime` predicates (`isToday`, `isTomorrow`, `age()`, …)
- `Map` predicates the SDK only has on `Iterable`
- `Enum.byNameOrNull` / `byNameOrElse` (the SDK only ships throwing `byName`)
- `Object.let` (Kotlin scope function)
- `LRUCache<K, V>`, `DisposableBag` — common patterns the SDK doesn't ship
- `FastHash.fnv1a`, `NetworkProbe.hasConnection`, `platformDispatch`, `TextFieldBuilders.disabledCounter`

```yaml
dependencies:
  fluiver: ^3.0.0
```

> **3.0 is a hard break.** All `BuildContext`, `TextStyle`, `EdgeInsets`,
> `BorderRadius`, `bool.toInt`, `DateTime.addX`, `String.capitalize`, and
> related "shortcut" extensions were removed. The single-dot shortcut
> framing collided with LLM-assisted development. Top-level helpers
> (`fastHash`, `hasDeviceConnection`, `platformSpecific`,
> `disabledInputCounterBuilder`) moved into domain-grouped static classes.
> See [CHANGELOG.md](CHANGELOG.md) for the full migration table.

---

## Install

```bash
dart pub add fluiver
```

```dart
import 'package:fluiver/fluiver.dart';
```

---

## Highlights

### Debounce / Throttle

```dart
final debounce = Debounce(const Duration(milliseconds: 300));

TextField(
  onChanged: (q) => debounce(() => search(q)),
);
```

`ThrottleFirst`, `ThrottleLast`, `ThrottleLatest` cover the rate-limit
variants. All four expose `dispose()`.

### FlexGrid — non-scrolling grid inside scrollables

```dart
ListView(
  children: [
    const Text('Featured'),
    FlexGrid(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: products.map(ProductCard.new).toList(),
    ),
  ],
);
```

Drop-in replacement for `GridView(shrinkWrap: true)` without the
performance penalty. Custom `RenderObject` — does not scroll itself.

### Observers

```dart
final obs = LocaleObserver((locales) => ...);
WidgetsBinding.instance.addObserver(obs);
// also: BrightnessObserver((Brightness b) => ...)
//       AppLifecycleObserver((AppLifecycleState s) => ...)
```

### DateTime predicates

```dart
dt.isToday;
dt.isTomorrow;
dt.inThisYear;
dt.isWithinFromNow(const Duration(minutes: 5));
birthDate.age();
dt.withTimeOfDay(const TimeOfDay(hour: 9, minute: 0));
```

For arithmetic use stdlib: `dt.add(const Duration(days: 7))`.

### TimeOfDay

```dart
const TimeOfDay(hour: 9).onDate(DateTime.now());   // today 09:00
const TimeOfDay(hour: 9).onDate(meeting.day);      // any date 09:00
```

### SDK gap-fillers

```dart
// Enum — non-throwing lookups
MyEnum.values.byNameOrNull('foo');
MyEnum.values.byNameOrElse('foo', orElse: () => MyEnum.bar);

// Map — what Iterable already has
map.firstWhereOrNull((k, v) => v.isActive);
map.whereKeyType<String>();
map.whereValueType<int>();

// Iterable
list.separated((i) => const Divider());
```

### `Object.let` — Kotlin scope function

Bounded to `T extends Object` so it doesn't pollute autocomplete on
nullables. Use `?.let(...)` for null-aware chaining.

```dart
// 1. Null-aware transform — returns a value, not a side-effect
final port = env['PORT']?.let(int.parse);
final user = jsonResponse?.let(User.fromJson);

// 2. Inline widget construction via tear-off
Column(children: [
  Text(title),
  ?subtitle?.let(Text.new),
  ?avatarUrl?.let(NetworkImage.new),
]);

// 3. Chain pure transformations without temp vars
final hash = userId.toString().let(FastHash.fnv1a);
final slug = title.trim().toLowerCase().let(_sluggify);

// 4. Conditional spread of children
Column(children: [
  Text(title),
  ...?subtitle?.let((s) => [const SizedBox(height: 4), Text(s)]),
]);

// 5. Static method as transform — no lambda
final id = rawId?.let(int.tryParse);
```

Don't reach for `.let` for side-effect-only calls (returns a value —
wasted), multi-line bodies (use a temp), or chains beyond three.

### LRUCache / DisposableBag

```dart
final cache = LRUCache<String, User>(maxEntries: 100);
cache['alice'] = user;
final hit = cache['alice'];          // promotes to most-recently-used

final bag = DisposableBag()
  ..add(debounce.dispose)
  ..add(subscription.cancel)
  ..add(controller.dispose);
await bag.dispose();
```

### Static helpers

```dart
if (await NetworkProbe.hasConnection()) { /* online */ }

final h = FastHash.fnv1a('input');  // FNV-1a int64 (VM only, not Web)

final padding = platformDispatch<EdgeInsets>(
  android: () => const .all(8),
  ios: () => const .all(16),
);

TextField(buildCounter: TextFieldBuilders.disabledCounter);
```

---

## LLM rule file

A compact rule file ships at `rules/fluiver.md`. Drop it into your agent's
rules directory (`~/.claude/rules/`, `.cursor/rules/`, `.cursorrules`, or
the AntiGravity equivalent) so the agent reaches for fluiver APIs instead
of reinventing them — and stops trying to use the removed sugar.

---

## License

MIT.
