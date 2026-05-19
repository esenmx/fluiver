# fluiver

[![pub](https://img.shields.io/pub/v/fluiver.svg)](https://pub.dev/packages/fluiver)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**SDK gap-fillers for Flutter.** Every API passes the gap test — the Dart or Flutter SDK should have shipped it and didn't. No shortcut sugar, no `package:collection` overlap.

- Debounce/throttle helpers with proper disposal
- `FlexGrid` — non-scrolling grid safe inside `ListView` / `SingleChildScrollView`
- `TickerBuilder` — per-frame rebuild with elapsed `Duration`
- System observers (`Locale`, `Brightness`, `AppLifecycle`) for provider code
- `DateTime` predicates (`isToday`, `isTomorrow`, `age()`, …)
- `Map` predicates the SDK only has on `Iterable`
- `Enum.byNameOrNull` (the SDK only ships throwing `byName`)
- `Object.let` (Kotlin scope function)
- `LRUCache<K, V>`, `DisposableBag` — common patterns the SDK doesn't ship
- `FastHash.fnv1a`, `NetworkProbe.hasConnection`, `platformDispatch`, `TextFieldBuilders.disabledCounter`
- `Color.darken` / `.lighten` / `.contrastText`, `ScrollController.atTop` / `.atBottom` / `.animateToTop` / `.animateToBottom`, `Future.timeoutOrNull`, `Iterable.windowed`, `TextEditingController.setTextAndCaret`

```yaml
dependencies:
  fluiver: ^3.1.0
```

> **Upgrading from 2.x or earlier 3.x?** The 3.x line trims shortcut
> extensions and surface APIs aggressively. See [CHANGELOG.md](CHANGELOG.md)
> for full removal + migration tables.

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

For widget context use the matching `flutter_hooks` hook
(`useOnAppLifecycleStateChange`, `useOnPlatformBrightnessChange`). These
wrappers fill the gap in non-widget code.

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

Same shape for `BrightnessObserver` / `AppLifecycleObserver`.

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
// Enum — non-throwing lookup; chain ?? for a fallback
MyEnum.values.byNameOrNull('foo');
MyEnum.values.byNameOrNull('x') ?? .bar;

// Map — what Iterable already has
map.firstWhereOrNull((k, v) => v.isActive);
map.whereKeyType<String>();
map.whereValueType<int>();

// Iterable
list.separated((i) => const Divider());
[1, 2, 3, 4, 5].windowed(3); // ([1,2,3], [2,3,4], [3,4,5])
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
final hit = cache['alice']; // promotes to most-recently-used

final bag = DisposableBag()
  ..add(debounce.dispose)
  ..add(subscription.cancel)
  ..add(controller.dispose);
await bag.dispose();
```

### Static helpers

```dart
if (await NetworkProbe.hasConnection()) { /* online */ }

final h = FastHash.fnv1a('input'); // FNV-1a int64 (VM only, not Web)

final storeUrl = platformDispatch<Uri>(
  android: () {
    return Uri.parse('https://play.google.com/store/apps/details?id=com.example.app');
  },
  ios: () {
    return Uri.parse('https://apps.apple.com/app/id123456789');
  },
);

TextField(buildCounter: TextFieldBuilders.disabledCounter);
```

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
controller.atTop; // false when no client attached, then true at top
controller.atBottom;
await controller.animateToBottom(); // 250ms easeOut by default
await controller.animateToTop(duration: const Duration(milliseconds: 400));
```

### Future.timeoutOrNull

```dart
final user = await fetchUser().timeoutOrNull(const Duration(seconds: 2));
if (user == null) {
  showRetry();
}
```

Errors from the underlying future still propagate — only the timeout
itself is converted to `null`.

### TextEditingController.setTextAndCaret

```dart
controller.setTextAndCaret('hello'); // caret at end
controller.setTextAndCaret('hello', caret: 0); // caret at start
```

Setting `controller.text = ...` directly resets the caret to `0` — this
puts it where you asked instead.

---

## LLM rule

A consumer-side rule ships at `rules/flutter-fluiver.md`. Drop it into
your agent's rules directory (`~/.claude/rules/`, `.cursor/rules/`, or
the AntiGravity equivalent) so the agent reaches for fluiver APIs
instead of reinventing them.

---

## License

MIT.
