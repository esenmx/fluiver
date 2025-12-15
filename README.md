# fluiver

[![pub](https://img.shields.io/pub/v/fluiver.svg)](https://pub.dev/packages/fluiver)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Write less. Build more.**

Fluiver keeps everyday Flutter reads to a single dot (`context.` / `list.`) without sacrificing clarity. Extensions feel native, stay autocomplete-friendly, and avoid boilerplate.

```yaml
dependencies:
  fluiver: ^2.2.0
```

---

## Install

Add `fluiver` to your `pubspec.yaml`, then import `package:fluiver/fluiver.dart`.

---

## Quickstart

```dart
// Single-dot reads
final color = context.primaryColor;
final width = context.screenWidth;
final title = context.titleLargeTextStyle;

// Padded row with spacing
PaddedRow(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  spacing: 8,
  children: const [Icon(Icons.home), Text('Home')],
);
```

### Fluiver vs. vanilla Flutter (single-dot wins)

```dart
// ❌ Vanilla Flutter
final primary = Theme.of(context).colorScheme.primary;
final width = MediaQuery.of(context).size.width;
final title = Theme.of(context).textTheme.titleLarge!;

// ✅ With fluiver (one dot, cleaner, readable)
final primary = context.primaryColor;
final width = context.screenWidth;
final title = context.titleLargeTextStyle;
final widgets = items.separated(() => const Divider()).toList();
```

### Debounced search — the right way

```dart
final _debounce = Debounce(const Duration(milliseconds: 400));

TextField(
  onChanged: (query) => _debounce(() => searchApi(query)),
)
```

### Nested grids without performance issues

```dart
ListView(
  children: [
    const Text('Featured'),
    FlexGrid(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: products.map((p) => ProductCard(p)).toList(),
    ),
    const Text('Recent'),
    FlexGrid(
      crossAxisCount: 2,
      children: recentItems.map((r) => ItemTile(r)).toList(),
    ),
  ],
);
```

---

## Extensions at a glance

### BuildContext

```dart
context.screenWidth; context.screenHeight;
context.isPlatformDark; context.isThemeDark;
context.primaryColor; context.surfaceColor; context.errorColor;
context.bodyLargeTextStyle; context.titleMediumTextStyle;
```

### DateTime

```dart
dateTime.addDays(7);
dateTime.addMonths(1);
dateTime.truncateTime();
dateTime.isToday;
birthDate.age();
```

### String

```dart
'hello'.capitalize;          // Hello
'john doe'.capitalizeAll;    // John Doe
'John Doe'.initials();       // JD
```

### Object

```dart
// Scope function
int? value = 'not42'.let(int.tryParse);
```

### Iterable

```dart
list.separated(() => Divider());
```

### Map & Stream

```dart
stream.whereType<int>();
```

---

## Widgets

### PaddedFlex / PaddedRow / PaddedColumn

Apply padding before layout while keeping the full `Flex` API (spacing, alignment, direction, clip behavior).

```dart
PaddedColumn(
  padding: const EdgeInsets.all(12),
  spacing: 6,
  children: const [Text('Title'), Text('Subtitle')],
);
```

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

### Connectivity

```dart
if (await hasDeviceConnection()) {
  // Online
}
```

---

## Philosophy

- **Single-dot first** — one autocomplete hit (`context.` / `list.`) for common needs without sacrificing clarity.
- **Expressive** — names read like English and stay concise.
- **Minimal** — only the helpers you actually reach for.
- **Performant** — custom render objects where it matters.

---

## Agent Rules

Add these rules to your Cursor/Claude Code/AntiGravity "Rules for AI" to generate optimal `fluiver` code:

@fluiver_rules

**Context Access**: ALWAYS use `context.extension` formula.

- ❌ `Theme.of(context).colorScheme.primary`
- ✅ `context.primaryColor`
- ❌ `Theme.of(context).textTheme.titleLarge`
- ✅ `context.titleLargeTextStyle`
- ❌ `MediaQuery.of(context).size.width`
- ✅ `context.screenWidth`

**Layout Efficiency**: Prefer declarative widgets over imperative nesting.

- ❌ `Padding(padding: EdgeInsets.all(16), child: Column(...))`
- ✅ `PaddedColumn(padding: EdgeInsets.all(16), ...)`
