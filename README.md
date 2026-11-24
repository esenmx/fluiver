# fluiver

[![pub][pub-svg]][pub] [![points][points-svg]][score] [![CI][ci-svg]][ci]
[![license][license-svg]](LICENSE)

fluiver is a set of small widgets, extensions and helpers that the Flutter SDK
leaves out: a grid that doesn't scroll, debounce and throttle, an LRU cache,
date checks like `isToday`, and more.

## Why

Without it, you write these yourself in every app: a `Timer` and its cancel
logic behind each debounced search field, a `GridView` with `shrinkWrap: true`
and `NeverScrollableScrollPhysics` for every grid inside a `ListView` (and it
still throws inside `IntrinsicHeight`), system insets that pad a sheet above the
keyboard without doubling under a resizing `Scaffold`, calendar math for "today"
and "yesterday", an LRU cache. fluiver gives you each one, tested, and throws
(`ArgumentError`, `RangeError`, `StateError`) when it's misused instead of
quietly clamping. Nothing here duplicates `package:collection`, `package:async`
or `flutter_hooks`, so it works alongside them.

## Quick start

```bash
flutter pub add fluiver
```

```dart
import 'package:fluiver/fluiver.dart';

Widget agenda(List<DateTime> meetings) {
  return ListView(
    children: [
      const Text('Meetings'),
      // GridView.count's layout without its own scrolling:
      // no shrinkWrap, no NeverScrollableScrollPhysics.
      Grid.count(
        crossAxisCount: 3,
        children: [
          for (final start in meetings)
            Text(start.isToday ? 'Today' : '${start.month}/${start.day}'),
        ],
      ),
    ],
  );
}
```

## Widgets

### `Grid` — non-scrolling grid

`GridView`'s layout without its viewport — configured by the same
`SliverGridDelegate` family, with `Grid.count` / `Grid.extent` mirroring
`GridView.count` / `GridView.extent` 1:1. The drop-in for
`GridView(shrinkWrap: true)` inside `ListView` / `SingleChildScrollView`: no
repaint boundaries, no scroll semantics, and intrinsics/dry layout actually work
(a shrink-wrapped `GridView` throws inside `IntrinsicHeight`).

```dart
final featured = ListView(
  children: [
    const Text('Featured'),
    Grid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [for (var i = 0; i < 6; i++) Text('Product $i')],
    ),
  ],
);
```

Every constructor also takes `direction:` (the main axis) and `padding:`. Use
`GridView` when the grid itself scrolls (viewport recycling matters).

`Grid.count` and `Grid.extent` throw `ArgumentError` for a count, ratio or
maximum extent that isn't positive, and for spacing or `mainAxisExtent` that is
negative or not finite. Cells too big for a bounded box are clipped to it, and
debug builds report the overflow and paint the striped indicator.

### `TickerBuilder`

Rebuilds every frame, exposes the elapsed running `Duration` (time spent
disabled excluded).

```dart
Widget stopwatch({required bool done}) {
  return TickerBuilder(
    enabled: !done,
    builder: (context, elapsed) => Text('${elapsed.inSeconds}s'),
  );
}
```

`enabled: false` pauses it — no frames, `elapsed` held — e.g. once a countdown
ends. For per-frame side effects, pass `onTick` and keep `builder` pure.

### `ScrollTrackingExpandable`

Expand/collapse with a size animation that keeps the growing bottom edge visible
in the nearest `Scrollable` — an expanding tile near the bottom of a list no
longer overflows below the fold.

```dart
Widget shippingDetails({required bool expanded}) {
  return ScrollTrackingExpandable(
    isExpanded: expanded,
    // Extra breathing room below the bottom edge.
    scrollOffset: 16,
    child: const Text('Ships in 2–4 days. Free returns within 30 days.'),
  );
}
```

Collapse never scrolls; only expansion tracks. If there is no enclosing
`Scrollable`, the size animation still runs without scroll tracking. A negative
`duration` reports an `ArgumentError` when the widget builds.

### Insets: keyboard and status bar

The keyboard covers the fields of a bottom sheet. A form padded by
`MediaQuery.viewInsetsOf` pads twice under a resizing `Scaffold`, or leaves a
34px gap above the keyboard. A header color stops below the status bar, and the
status-bar icons stay white on a white screen. These three pieces get each case
right on iOS and Android.

`ViewInsetsPadding` lifts its child above the keyboard and tells everything
below that it did, so nothing pads twice:

```dart
Future<void> rename(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    // Without it the sheet stops at 9/16 of the screen and the field overflows.
    isScrollControlled: true,
    builder: (context) => const ViewInsetsPadding(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: .min,
          children: [Text('Rename'), TextField(autofocus: true)],
        ),
      ),
    ),
  );
}
```

It pads nothing where a `Scaffold` already resized for the keyboard, so a
reusable form is safe in a sheet, a page or a dialog. On a `Scaffold` that
doesn't resize and has a `bottomNavigationBar`, add `extendBody: true`, or it
pads the bar height twice. A chat composer goes in the bottom bar slot and rides
the keyboard, resizing `Scaffold` or not:

```dart
Widget chat(Widget messages, Widget composer) {
  return Scaffold(
    body: messages,
    bottomNavigationBar: ViewInsetsPadding(child: composer),
  );
}
```

`StatusBarHeader` is a colored header for a screen without an `AppBar`: the
color reaches behind the status bar, the child sits below it, and the status-bar
icons contrast the color:

```dart
Widget profile(String name) {
  return Scaffold(
    body: Column(
      // The header is as wide as its child; stretch it across the screen.
      crossAxisAlignment: .stretch,
      children: [
        StatusBarHeader(
          color: Colors.indigo,
          child: Padding(
            padding: const .all(16),
            child: Text(
              name,
              style: TextStyle(color: Colors.indigo.contrastText),
            ),
          ),
        ),
        const Expanded(child: Placeholder()),
      ],
    ),
  );
}
```

It throws `ArgumentError` for a translucent color, and `StateError` under a
`SafeArea`, an `AppBar`, a `ListView` or a modal sheet, where it can't reach the
status bar. A `ListView` below it in the `Column` still pads for the status bar;
with a list, make the header the first sliver of a `CustomScrollView`. For a
gradient or an image, use `StatusBarIcons` below.

`StatusBarIcons.light` and `.dark` set the status-bar icons on iOS and Android,
exactly as an `AppBar` derives them. `SystemUiOverlayStyle.light` and `.dark`
also paint the Android navigation bar black.

```dart
final blackAppBar = AppBar(
  backgroundColor: Colors.black,
  systemOverlayStyle: StatusBarIcons.light,
);

// A dark hero image at the top of a page without an AppBar.
Widget hero(ImageProvider image) {
  return AnnotatedRegion(
    value: StatusBarIcons.light,
    child: Image(image: image, height: 300, fit: .cover),
  );
}
```

A colored bottom bar needs no widget: put the color outside the `SafeArea`, so
it reaches under the home indicator.

```dart
Widget bottomBar(Widget actions) {
  return ColoredBox(
    color: Colors.indigo,
    child: SafeArea(top: false, child: actions),
  );
}
```

## Extensions

### `Object.into` — Kotlin's `let`

Named so it doesn't clash with other packages' `.let`. Bounded to
`T extends Object` so it doesn't pollute autocomplete on nullables. Use
`?.into(...)` for null-aware chaining.

```dart
// Null-aware transform — returns a value, not a side effect
int? port(Map<String, String> env) => env['PORT']?.into(int.parse);

// Inline widget construction via tear-off
Widget header(String title, {String? subtitle, String? avatarUrl}) {
  return Column(
    children: [
      Text(title),
      ?subtitle?.into(Text.new),
      ?avatarUrl?.into(Image.network),
    ],
  );
}

// Chain pure transforms without temp vars
int userKey(int userId) => userId.toString().into(FastHash.fnv1a);
String pathSegment(String title) =>
    title.trim().toLowerCase().into(Uri.encodeComponent);
```

Skip `.into` for side-effect-only calls, multi-line bodies, or chains beyond
three.

### Iterable / Map / Enum gap-fillers

```dart
// Enum — non-throwing lookup, no asNameMap() allocation
Brightness themeFrom(String saved) =>
    Brightness.values.byNameOrNull(saved) ?? .light;

// Map — filters that return a Map, not an entry iterable
final json = <Object, Object?>{'id': 1, 'name': 'Ada', 2: null};
final present = json.where((key, value) => value != null);
final named = json.whereKeyType<String>(); // Map<String, Object?>
final ints = json.whereValueType<int>(); // Map<Object, int>: {'id': 1}
// null only when the key is absent: entryOf(2) is MapEntry(2: null)
final entry = json.entryOf(2);

// Iterable
final rows = const <Widget>[
  Text('A'),
  Text('B'),
].intersperse((i) => const Divider()); // A, Divider, B
final windows = [1, 2, 3, 4, 5].slidingWindows(3);
// ([1, 2, 3], [2, 3, 4], [3, 4, 5])
```

### DateTime predicates

```dart
final dt = DateTime.now();
final today = dt.isToday;
final tomorrow = dt.isTomorrow;
final yesterday = dt.isYesterday;
final thisYear = dt.inThisYear;
final recent = dt.isWithinFromNow(const Duration(minutes: 5));

final birthday = DateTime(1990, 5, 17);
final age = birthday.age(); // full years as of now
final ageIn2030 = birthday.age(at: DateTime(2030));

final midnight = dt.dateOnly; // keeps UTC, unlike DateUtils.dateOnly
final nineToday = const TimeOfDay(hour: 9, minute: 0).onDate(dt);
```

Arithmetic stays on stdlib. `dt.copyWith(day: dt.day + 7)` moves seven calendar
days and keeps UTC; `dt.add(const Duration(days: 7))` adds 168 hours, so the
wall-clock time shifts by an hour across a DST change.

### TimeOfDay

```dart
const nine = TimeOfDay(hour: 9, minute: 0);
final today = nine.onDate(DateTime.now()); // today 09:00
final launch = nine.onDate(DateTime(2030, 1, 15)); // any date 09:00
```

`onDate(date)` takes the calendar day explicitly — no hidden `DateTime.now()`,
deterministic in tests. It extends `package:material_ui/material_ui.dart`'s
`TimeOfDay`.

### `Future.timeoutOrNull`

```dart
Future<String> greeting(Future<String> Function() fetchName) async {
  final name = await fetchName().timeoutOrNull(const Duration(seconds: 2));
  if (name == null) {
    return 'Hello!'; // timed out
  }
  return 'Hello, $name!';
}
```

Only timeout becomes `null`; errors from the underlying future still propagate.
Available only on futures of non-nullable values, so `null` can't also be a real
result. A negative timeout throws `ArgumentError`.

### Color — HSL transforms

```dart
const brand = Color(0xFF6750A4);
final pressed = brand.darker();
final hover = brand.lighter();

final tag = ColoredBox(
  color: brand,
  child: Text('New', style: TextStyle(color: brand.contrastText)),
);
```

`darker` and `lighter` shift HSL lightness by `amount`, a fraction on its
`[0, 1]` scale (default `0.1`), not a percentage. `amount` must be within
`[0, 1]` (`RangeError` otherwise). A color with a channel outside `[0, 1]`
(extended sRGB) throws `ArgumentError`: map it into gamut first, the way you
want.

### ScrollController — position + edge animation

```dart
Future<void> showLatest(ScrollController controller) async {
  // atTop / atBottom: true when every attached view is at that edge.
  if (!controller.atBottom) {
    await controller.animateToBottom(); // 250ms easeOut by default
  }
}

Future<void> backToTop(ScrollController controller) =>
    controller.animateToTop(duration: const Duration(milliseconds: 400));
```

Like `ScrollController.position`, every member throws `StateError` when no
scroll view is attached; check `controller.hasClients` first if it may not be.
`animateToTop` and `animateToBottom` throw `ArgumentError` unless `duration` is
positive.

### TextEditingController — set text and caret together

```dart
final controller = TextEditingController()
  ..setTextAndCaret('hello') // caret at end
  ..setTextAndCaret('hello', caret: 0); // caret at start
```

Setting `controller.text = ...` directly drops the selection to invalid (offset
`-1`), and a focused field then repairs it its own way: the caret at the end on
mobile and in multiline fields, the whole text selected in a single-line desktop
field. This keeps it valid and puts it where you asked, focused or not. A
`caret` outside `0..text.length` throws `RangeError`.

## Helpers

### Debounce / Throttle

```dart
// dispose() it with its owner, e.g. in State.dispose.
final debounce = Debounce(const Duration(milliseconds: 300));

Widget searchField(ValueChanged<String> search) {
  return TextField(onChanged: (query) => debounce(() => search(query)));
}
```

| Variant | Fires |
| --- | --- |
| `Debounce` | once calls stop for the duration (search-as-you-type, autosave) |
| `ThrottleFirst` | the first call, then drops calls until the window ends (submit, anti rage-click) |
| `ThrottleLast` | the last call made during the window, when it ends (scroll position save, slider end) |
| `ThrottleLatest` | the first call at once, then the latest call of each window as it ends (live preview) |

All four are callable, throw `ArgumentError` for a negative duration, expose
`dispose()`, and throw `StateError` if called or disposed again after disposal.

### `LRUCache`

```dart
final cache = LRUCache<String, DateTime>(maxEntries: 100);

// Lazy on miss; a hit promotes the entry to most-recently-used.
DateTime parse(String iso) => cache.putIfAbsent(iso, () => DateTime.parse(iso));

cache['epoch'] = DateTime.utc(1970);
final hit = cache['epoch']; // promotes to most-recent
final peeked = cache.peek('epoch'); // no promotion
// keys, values and entries are snapshots, least-recently-used first
for (final MapEntry(:key, :value) in cache.entries) {
  debugPrint('$key: $value');
}
```

For async loads, type it `LRUCache<K, Future<V>>` so concurrent misses share one
future.

### `DisposableBag`

```dart
final debounce = Debounce(const Duration(milliseconds: 300));
final controller = TextEditingController();
final subscription = Stream<void>.periodic(const Duration(seconds: 1))
    .listen((_) => debugPrint('tick'));

final bag = DisposableBag()
  ..add(debounce.dispose)
  ..addAll([subscription.cancel, controller.dispose]);
// Once, from State.dispose or ref.onDispose:
await bag.dispose();
```

Async disposers start in registration order but are awaited together; dependent
steps (flush, then close) go in one closure. Every `dispose()` call returns the
same future; `add` after it settled throws `StateError`.

### Listeners

These wrappers fill the gap for providers — non-widget code that holds a
device-state listenable. Like the framework's `AppLifecycleListener`, each one
registers itself on construction and stops on `dispose()`. In a widget, use
`flutter_hooks`' `useOnPlatformBrightnessChange` for brightness; `flutter_hooks`
ships no locale hook, so mix `WidgetsBindingObserver` into the `State` for
locales.

```dart
final locales = ValueNotifier<List<Locale>?>(
  WidgetsBinding.instance.platformDispatcher.locales,
);
final listener = LocaleListener((next) => locales.value = next);
// Call listener.dispose() when the owner goes away.
```

In a Riverpod notifier, create the listener in `build()` with
`(locales) => state = locales`, register `ref.onDispose(listener.dispose)`, and
return `PlatformDispatcher.instance.locales`. Same shape for
`BrightnessListener`. App lifecycle needs no wrapper — the framework's
`AppLifecycleListener` already is one.

### Network, hashing, platform, TextField

```dart
// Native only (TCP); throws UnsupportedError on web.
// A negative timeout throws ArgumentError everywhere.
if (await NetworkProbe.checkConnection()) {
  debugPrint('online');
}
// Web only; false only when the browser knows it is offline.
if (NetworkProbe.isBrowserOnline()) {
  debugPrint('not known to be offline');
}

// FNV-1a-64 over UTF-16BE code units (≠ FNV-1a over UTF-8).
// Throws on JS web; VM and Wasm are fine.
final hash = FastHash.fnv1a('input');

final storeUrl = platformDispatch<String>(
  android: () =>
      'https://play.google.com/store/apps/details?id=com.example.app',
  ios: () => 'https://apps.apple.com/app/id123456789',
);

const field = TextField(buildCounter: TextFieldBuilders.disabledCounter);
```

## Agent skill

This package ships an agent skill in `skills/fluiver-usage/`, so coding agents
reach for these helpers instead of writing their own. Install it into your
project's agent config with:

```sh
dart run skills@ get --package fluiver --all
```

## Name

**flu**tter + [**quiver**](https://github.com/google/quiver-dart) — same spirit
as Google's archived Dart utility library, scoped to what Flutter apps need
today.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).

[pub]: https://pub.dev/packages/fluiver
[pub-svg]: https://img.shields.io/pub/v/fluiver.svg
[score]: https://pub.dev/packages/fluiver/score
[points-svg]: https://img.shields.io/pub/points/fluiver
[ci]: https://github.com/esenmx/fluiver/actions/workflows/ci.yaml
[ci-svg]: https://github.com/esenmx/fluiver/actions/workflows/ci.yaml/badge.svg
[license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
