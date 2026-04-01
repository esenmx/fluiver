# Changelog

## 2.4.2

- Removed `is*` enum getters; use shorthand comparisons (`x == .ltr`).
- Improved `hasDeviceConnection` (socket + timeout).
- Added `disabledInputCounterBuilder`.
- Removed `StreamWhereType` (duplicates `dart:async`).
- Renamed `inToday` → `todayAt`, fixed `BuildContextsColorScheme` typo.
- Doc and README fixes.

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
