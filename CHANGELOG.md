# Changelog

## 3.2.2

- **Fixed** — `FastHash.fnv1a`'s 64-bit offset-basis literal broke compilation on web targets (including `flutter widget-preview`). Now split into web-representable halves (bit-exact on the VM); throws `UnsupportedError` on web instead of corrupting hashes.

## 3.2.1

- **Changed** — Dropped `@useResult` from `Object.let`; the result can now be safely ignored (e.g. side-effecting transforms) without an analyzer warning.
- **Changed** — LLM artifact moved from a path-scoped rule to a description-triggered skill (`tool/claude/flutter-fluiver/SKILL.md`); loaded by relevance instead of on every `lib/` / `test/` file.

## 3.2.0

- **Added** — `LRUCache.putIfAbsent(K key, V Function() ifAbsent)`. Lazy compute on miss; hit promotes the entry to most-recently-used.
- **Added** — `DisposableBag.addAll(Iterable<FutureOr<void> Function()>)`. Bulk-register disposers; same semantics as repeated `add`.
- **Changed** — Rule file no-overlap callout narrowed to `package:collection` and `package:async`.

## 3.1.0

- **Added** — `Color.darken([amount])`, `Color.lighten([amount])`, `Color.contrastText`. HSL-based; `contrastText` picks black or white via luminance.
- **Added** — `ScrollController.atTop`, `.atBottom`, `.animateToTop({duration, curve})`, `.animateToBottom({duration, curve})`. `hasClients`-safe.
- **Added** — `Future<T>.timeoutOrNull(Duration)` → `Future<T?>`. Null on timeout, errors still propagate.
- **Added** — `Iterable<E>.windowed(int size, {int step = 1})`. Stepped sliding window; drops partial trailing window.
- **Added** — `TextEditingController.setTextAndCaret(String, {int? caret})`. Avoids the `controller.text = ...` caret-reset papercut.
- **Changed** — LLM artifact moved from `rules/fluiver.md` to `rules/flutter-fluiver.md`. Namespaced with the `flutter-` prefix.
- **Removed** — `PaddedFlex` / `PaddedRow` / `PaddedColumn` widgets. Use `Padding(padding: ..., child: Column(children: [...]))` / `Row` — LLMs reach for this natively.
- **Removed** — `IterableEnum.byNameOrElse(name, orElse: ...)`. Use `Enum.values.byNameOrNull(name) ?? .fallback` — Dart shorthand handles the fallback.

## 3.0.0

**Breaking — utility-library pivot.** The "single-dot shortcut" framing collided with LLM-assisted development: agents do not know the extensions exist, default to stdlib forms, and teaching the API costs input tokens on every turn. The sugar layer had to go. What remains is substance — things the SDK is genuinely missing. Ships a compact rule file at `rules/fluiver.md` for consumer projects to load into their LLM agent.

- **Removed** — `extensions/build_context.dart` (`context.primaryColor`, `context.titleLargeTextStyle`, `context.screenWidth`, `context.isThemeDark`, …). Use `Theme.of(context).colorScheme.primary`, `Theme.of(context).textTheme.titleLarge`, `MediaQuery.sizeOf(context).width`, `Theme.of(context).brightness == Brightness.dark`.
- **Removed** — `extensions/text_style.dart` (`withColor`, `withWeight400`, `withSize`, `withUnderline`, …). Use `style.copyWith(color: ..., fontWeight: FontWeight.w400, fontSize: ...)`.
- **Removed** — `extensions/edge_insets.dart` (`addLeft`, `onlyTop`, `setRight`, `withStatusBarMargin`, …). Use `EdgeInsets.only(...)`, `.copyWith(...)`, `MediaQuery.viewPaddingOf(context).top`.
- **Removed** — `extensions/border_radius.dart` (`addAll`, `onlyTopLeft`, `setBottomRight`, …). Use `BorderRadius.only(...)`, `.copyWith(...)`.
- **Removed** — `extensions/bool.dart` (`toInt`). Use `b ? 1 : 0`.
- **Removed** — `extensions/date_time.dart` arithmetic (`addYears`, `addMonths`, `addWeeks`, `addDays`, `addHours`, `addMinutes`, `addSeconds`). Use `dt.add(Duration(days: N))` / `DateTime(y + n, m, d)`.
- **Removed** — `extensions/key.dart` (`validateAndSave` on `GlobalKey<FormFieldState<T>>`). Use `if (k.currentState!.validate()) k.currentState!.save();`.
- **Removed** — `extensions/flutter_enums.dart` (`Axis.reverse`, `TextDirection.reverse`, `Brightness.reverse`, `Orientation.reverse`). Use inline ternary.
- **Removed** — `extensions/string.dart` (`capitalize`, `capitalizeAll`, `initials`, `safeSubstring`). Inline.
- **Renamed** — `fastHash(s)` → `FastHash.fnv1a(s)`. Namespace, algorithm-named, future-proof for other hashes.
- **Renamed** — `hasDeviceConnection()` → `NetworkProbe.hasConnection({timeout})`. Namespaced; `timeout` is now configurable.
- **Renamed** — `platformSpecific<T>(...)` → `platformDispatch<T>(...)`. Clearer name; matches `compute` / `dispatch` mental model.
- **Renamed** — `disabledInputCounterBuilder` → `TextFieldBuilders.disabledCounter`. Namespaced; room for more `TextField` helpers.
- **Renamed** — `TimeOfDay.todayAt()` → `TimeOfDay.onDate(DateTime date)`. Takes the calendar day explicitly — testable, no hidden `DateTime.now()`.
- **Fixed** — `Map.entryOf(k)` distinguishes "key absent" from "key present with null value"; previously returned `null` for both. `{'a': null}.entryOf('a')` now returns `MapEntry('a', null)`.
- **Fixed** — `DateTime.isTomorrow` / `isYesterday` used `Duration(days: 1)` (24h), which crosses DST fall-back days incorrectly. Now uses calendar-day arithmetic (`DateTime(y, m, d ± 1)`).
- **Fixed** — `NetworkProbe.hasConnection` short-circuits to `true` on web (previous `dart:io.Socket` call would have thrown at runtime), narrows its catch to `SocketException` / `TimeoutException` (no more swallowing programming bugs), and exposes the timeout as a parameter.
- **Fixed** — `PaddedFlex.textDirection` / `textBaseline` default to `null` — `Flex` resolves from ambient `Directionality`. Previously hardcoded `TextDirection.ltr` broke RTL layouts.
- **Fixed** — `TickerBuilder.initState` calls `super.initState()` before starting the ticker.
- **Fixed** — `ThrottleLast._last` initialized to a no-op closure instead of `late VoidCallback`.
- **Fixed** — `Let<T>` extension is now bounded to `T extends Object`, so `.let` no longer pollutes autocomplete on nullable receivers. Use `?.let(...)` for null-aware chaining.
- **Added** — `LRUCache<K, V>(maxEntries: N)`. Bounded least-recently-used cache; O(1) reads / writes / eviction; reads / writes promote.
- **Added** — `DisposableBag`. Collect `dispose` / `cancel` / `close` closures and flush in registration order with a single `dispose()`. Idempotent; adding after dispose runs the closure immediately.
- **Added** — `rules/fluiver.md`. Compact rule file for LLM agents; documents the surviving API surface and steers away from removed identifiers.

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
