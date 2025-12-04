# fluiver

[![pub](https://img.shields.io/pub/v/fluiver.svg)](https://pub.dev/packages/fluiver)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Write less. Build more.**

Stop typing `Theme.of(context).colorScheme.primary` or `MediaQuery.of(context).size.width`. Fluiver gives you expressive, IDE-friendly extensions that feel native to Flutter.

```yaml
dependencies:
  fluiver: ^2.0.0
```

---

## Why fluiver?

```dart
// ❌ Before
final color = Theme.of(context).colorScheme.primary;
final width = MediaQuery.of(context).size.width;
final style = Theme.of(context).textTheme.bodyLarge!;

// ✅ After
final color = context.primaryColor;
final width = context.screenWidth;
final style = context.bodyLargeTextStyle;
```

Every extension is designed for **discoverability** — just type `context.` and let autocomplete do the rest.

---

## Showcase

### ⏱️ Build a stopwatch in 5 lines

```dart
TickerBuilder(
  builder: (context, elapsed) => Text(
    '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
    style: context.displayLargeTextStyle,
  ),
)
```

### 🔍 Debounced search — the right way

```dart
final _debounce = Debounce(Duration(milliseconds: 400));

TextField(
  onChanged: (query) => _debounce(() => searchApi(query)),
)
```

### 📐 Nested grids without performance issues

```dart
// ❌ GridView with shrinkWrap: true rebuilds everything
// ✅ FlexGrid uses custom RenderObject — zero overhead

SingleChildScrollView(
  child: Column(
    children: [
      Text('Featured'),
      FlexGrid(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: products.map((p) => ProductCard(p)).toList(),
      ),
      Text('Recent'),
      FlexGrid(
        crossAxisCount: 2,
        children: recentItems.map((r) => ItemTile(r)).toList(),
      ),
    ],
  ),
)
```

---

## Extensions

### BuildContext

```dart
// Screen
context.screenWidth
context.screenHeight

// Brightness
context.isPlatformDark
context.isThemeDark

// Colors (includes all ColorScheme colors)
context.primaryColor
context.surfaceColor
context.errorColor

// TextStyles (includes all TextTheme styles)
context.bodyLargeTextStyle
context.titleMediumTextStyle
```

### DateTime

```dart
dateTime.addDays(7)
dateTime.addMonths(1)
dateTime.truncateTime()
dateTime.isToday
dateTime.isTomorrow
birthDate.age()  // Accurate age calculation
```

### String

```dart
'hello'.capitalize          // Hello
'john doe'.capitalizeAll    // John Doe
'John Doe'.initials()       // JD
```

### Iterable

```dart
list.firstWhereOrNull((e) => e.id == 1)
list.groupAsMap((e) => e.category)  // {category: [e1, e2, e3]}
list.separate(() => Divider())  // [e1, Divider(), e2, Divider(), e3]
[1, 2, 3, 4].to2D(2)  // [[1, 2], [3, 4]]

// Numeric
[1, 2, 3].sum()       // 6
[1, 2, 3].average()   // 2
[5, 1, 3].lowest()      // 1
[5, 1, 3].highest()     // 5
```

---

## Widgets

### FlexGrid

Non-scrolling grid built with custom `RenderObject`. Drop-in replacement for `GridView` with `shrinkWrap: true` — without the performance penalty.

```dart
FlexGrid(
  crossAxisCount: 3,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  padding: EdgeInsets.all(16),
  children: [...],
)
```

### TickerBuilder

Frame-by-frame rebuilds with elapsed duration. Perfect for timers and animations.

```dart
TickerBuilder(
  builder: (context, elapsed) => Text('${elapsed.inSeconds}s'),
)
```

---

## Helpers

### Debounce & Throttle

```dart
final debounce = Debounce(Duration(milliseconds: 300));
onChanged: (text) => debounce(() => search(text));

final throttle = ThrottleFirst(Duration(seconds: 1));
onTap: () => throttle(() => submit());
```

### Observers

React to system changes without boilerplate.

```dart
LocaleObserver((locales) => ...);
BrightnessObserver((brightness) => ...);
AppLifecycleObserver((state) => ...);
```

---

## Philosophy

- **Expressive** — APIs that read like English
- **Discoverable** — IDE autocomplete friendly
- **Minimal** — Only what you'll actually use
- **Performant** — Custom render objects where it matters

---

## License

MIT
