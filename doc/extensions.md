# Extensions

## `Object.into` — Kotlin's `let`

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

## Iterable / Map / Enum gap-fillers

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

## DateTime predicates

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

## TimeOfDay

```dart
const nine = TimeOfDay(hour: 9, minute: 0);
final today = nine.onDate(DateTime.now()); // today 09:00
final launch = nine.onDate(DateTime(2030, 1, 15)); // any date 09:00
```

`onDate(date)` takes the calendar day explicitly — no hidden `DateTime.now()`,
deterministic in tests. It extends `package:material_ui/material_ui.dart`'s
`TimeOfDay`.

## `Future.timeoutOrNull`

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

## Color — HSL transforms

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

## ScrollController — position + edge animation

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

## TextEditingController — set text and caret together

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
