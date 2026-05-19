# Changelog

## 3.0.0

**Breaking — utility-library pivot.**

The "single-dot shortcut" framing collided with LLM-assisted development:
agents do not know the extensions exist, default to stdlib forms, and
teaching the API costs input tokens on every turn. The sugar layer had to
go. What remains is substance — things the SDK is genuinely missing.

Ships a compact rule file at `rules/fluiver.md` for consumer projects to
load into their LLM agent.

### Removed

| Removed | Replacement |
| --- | --- |
| `extensions/build_context.dart` (all `context.primaryColor`, `context.titleLargeTextStyle`, `context.screenWidth`, `context.isThemeDark`, etc.) | `Theme.of(context).colorScheme.primary`, `Theme.of(context).textTheme.titleLarge`, `MediaQuery.sizeOf(context).width`, `Theme.of(context).brightness == Brightness.dark` |
| `extensions/text_style.dart` (`withColor`, `withWeight400`, `withSize`, `withUnderline`, ...) | `style.copyWith(color: ..., fontWeight: FontWeight.w400, fontSize: ...)` |
| `extensions/edge_insets.dart` (`addLeft`, `onlyTop`, `setRight`, `withStatusBarMargin`, ...) | `EdgeInsets.only(...)`, `.copyWith(...)`, `MediaQuery.viewPaddingOf(context).top` |
| `extensions/border_radius.dart` (`addAll`, `onlyTopLeft`, `setBottomRight`, ...) | `BorderRadius.only(...)`, `.copyWith(...)` |
| `extensions/bool.dart` (`toInt`) | `b ? 1 : 0` |
| `extensions/date_time.dart` arithmetic (`addYears`, `addMonths`, `addWeeks`, `addDays`, `addHours`, `addMinutes`, `addSeconds`) | `dt.add(Duration(days: N))` / `DateTime(y + n, m, d)` |
| `extensions/key.dart` (`validateAndSave` on `GlobalKey<FormFieldState<T>>`) | `if (k.currentState!.validate()) k.currentState!.save();` |
| `extensions/flutter_enums.dart` (`Axis.reverse`, `TextDirection.reverse`, `Brightness.reverse`, `Orientation.reverse`) | inline ternary |
| `extensions/string.dart` (`capitalize`, `capitalizeAll`, `initials`, `safeSubstring`) | inline |

### Renamed / Refactored

| Before | After | Why |
| --- | --- | --- |
| top-level `fastHash(s)` | `FastHash.fnv1a(s)` | namespace, algorithm-named, future-proof for other hashes |
| top-level `hasDeviceConnection()` | `NetworkProbe.hasConnection({timeout})` | namespaced, `timeout` is now configurable |
| top-level `platformSpecific<T>(...)` | top-level `platformDispatch<T>(...)` | clearer name; matches `compute`/`dispatch` mental model |
| top-level `disabledInputCounterBuilder` | `TextFieldBuilders.disabledCounter` | namespaced; room for more `TextField` helpers |
| `TimeOfDay.todayAt()` | `TimeOfDay.onDate(DateTime date)` | takes the calendar day explicitly — testable, no hidden `DateTime.now()` |

### Fixed

- `Map.entryOf(k)` distinguishes "key absent" from "key present with null value"; previously returned `null` for both. `{'a': null}.entryOf('a')` now returns `MapEntry('a', null)`.
- `DateTime.isTomorrow` / `isYesterday` used `Duration(days: 1)` (24h), which crosses DST fall-back days incorrectly. Now uses calendar-day arithmetic (`DateTime(y, m, d ± 1)`).
- `NetworkProbe.hasConnection` now short-circuits to `true` on web (previous `dart:io.Socket` call would have thrown at runtime), narrows its catch to `SocketException`/`TimeoutException` (no more swallowing programming bugs), and exposes the timeout as a parameter.
- `PaddedFlex.textDirection` / `textBaseline` default to `null` — `Flex` resolves from ambient `Directionality`. Previously hardcoded `TextDirection.ltr` broke RTL layouts.
- `TickerBuilder.initState` calls `super.initState()` before starting the ticker.
- `ThrottleLast._last` initialized to a no-op closure instead of `late VoidCallback`.
- `Let<T>` extension is now bounded to `T extends Object`, so `.let` no longer pollutes autocomplete on nullable receivers. Use `?.let(...)` for null-aware chaining.

### Added

- `LRUCache<K, V>(maxEntries: N)` — bounded least-recently-used cache; O(1) reads/writes/eviction; reads/writes promote.
- `DisposableBag` — collect `dispose` / `cancel` / `close` closures and flush in registration order with a single `dispose()`. Idempotent; adding after dispose runs the closure immediately.
- `rules/fluiver.md` — compact rule file for LLM agents; documents the surviving API surface and steers away from removed identifiers.

### Kept

- Widgets: `FlexGrid`, `TickerBuilder`, `PaddedFlex`/`PaddedRow`/`PaddedColumn`
- Reactive: `Debounce`, `ThrottleLatest`, `ThrottleFirst`, `ThrottleLast`
- Observers: `LocaleObserver`, `BrightnessObserver`, `AppLifecycleObserver`
- DateTime predicates + merge: `isToday`, `isTomorrow`, `isYesterday`, `inThisYear`, `isWithinFromNow`, `age()`, `truncateTime`, `withTimeOfDay`, `toTimeOfDay`
- Enum: `EnumIndexComparable` mixin, `byNameOrNull`, `byNameOrElse`
- Iterable: `separated`
- Map: `any`, `every`, `firstWhereOrNull`, `where`, `whereKeyType`, `whereValueType`, `entryOf`
- Object: `let`

## 2.4.3

- Removed `StreamWhereType` (duplicates `dart:async`).
- Renamed `inToday` → `todayAt`, fixed `BuildContextsColorScheme` typo.
- Doc fixes.

## 2.4.2

- Removed `is*` enum getters; use shorthand comparisons (`x == .ltr`).
- Improved `hasDeviceConnection` (socket + timeout).
- Added `disabledInputCounterBuilder`.

## 2.4.1

- Broadened SDK constraint to `>=3.10.0 <4.0.0`.

## 2.4.0

- Added `platformSpecific` utility.
- Modernized observers to use `PlatformDispatcher`.
- Adopted shorthand enum values throughout.
- Fixed `ThrottleLast` task execution.

## 2.3.0

- Added `index` parameter to `Iterable.separated`.
- Added `let` scope extension on `Object`.
- Renamed `deviceHasConnection` → `hasDeviceConnection`.
- Added `fastHash`.

## 2.2.0

- Removed `Iterable` extensions that duplicate `package:collection`.
- Renamed `Iterable.separate` → `Iterable.separated`.

## 2.1.0

- Added `PaddedFlex`, `PaddedRow`, `PaddedColumn`.

## 2.0.0

- **Breaking:** `FlexGrid` rewritten as `MultiChildRenderObjectWidget`.
- Added `FlexGrid.padding`, all M3 `ColorScheme` context getters.
- Removed `BezierSquircleBorder`. Min SDK Dart 3.0.0.

## 1.2.0

- Added `ColorScheme` context getters, `BezierSquircleBorder`, `StreamWhereType`.

## 1.1.1

- Added `TickerBuilder.onTick`.

## 1.1.0

- Added `TickerBuilder`.

## 1.0.1

- Updated `MediaQuery` lookups; removed `elementAtOrNull`, `singleOrNull` (now in core).

## 1.0.0

- Initial release.
