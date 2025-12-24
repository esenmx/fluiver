# Changelog

## 2.4.1

- Broadened SDK constraint to `>=3.10.0 <4.0.0`.

## 2.4.0

- Added `platformSpecific` utility function.
- Modernized `LocaleObserver` and `BrightnessObserver` using `PlatformDispatcher`.
- Adopted shorthand enum values throughout the library.
- Improved `AppLifecycleState` and other enum extensions.
- Fixed `ThrottleLast` task execution.
- Updated minimum SDK to 3.10.1.

## 2.3.0

- Added `index` parameter to `separator` in `Iterable.separated` extension method.
- Added `let<R>(R Function(T it) fn)` extension to `Object` for scope functions.
- Renamed `deviceHasConnection` to `hasDeviceConnection` for clarity.
- Added `fastHash` function.

## 2.2.0

Refactored `Iterable` extensions to complement the `package:collection` methods instead of duplicating them.
Here removed extension methods and their equivalents in `package:collection` as follows:

- `Iterable<Widget>.slicedWidgetsBuilder` => `Iterable.groupListsBy`
- `Iterable.firstWhereOrNull`, `Iterable.lastWhereOrNull`, `Iterable.whereNot` =>  `Iterable.firstWhereOrNull`, `Iterable.lastWhereOrNull`, `Iterable.whereNo`.
- `Iterable.groupAsMap` => `Iterable.groupFoldBy`, `Iterable.groupListsBy`, `Iterable.groupSetsBy`
- `Iterable.to2D` => `Iterable.slices`
- `Iterable.earliest`, `Iterable.latest` => `Iterable.minBy`, `Iterable.maxBy`
- `Iterable<num>.sum`, `Iterable<num>.average`, `Iterable<num>.lowest`, `Iterable<num>.highest` => `Iterable<num>.sum`, `Iterable<num>.average`, `Iterable<num>.min`, `Iterable<num>.max`
- `Iterable<Iterable>.flatten` => `Iterable<Iterable>.flattened`, `Iterable<Iterable>.flattenedToList`, `Iterable<Iterable>.flattenedToSet`
- `Iterable.sliced` => `Iterable.skip()` + `Iterable.take()` combination
- `List.safeSubList` => `Iterable.skip()` + `Iterable.take()` combination
- `Set.subSet` => `Iterable.skip()` + `Iterable.take()` + `Iterable.toSet()` combination

Renamed these extension methods:

- `Iterable.separate` => `Iterable.separated`

## 2.1.0

- Added `PaddedFlex`, `PaddedRow` and `PaddedColumn` wrappers

## 2.0.0

### Breaking

- `FlexGrid` rewritten as `MultiChildRenderObjectWidget` for better performance
- `FlexGrid` now accepts `children` directly (removed generic type parameter)
- Minimum SDK raised to Dart 3.0.0

### Added

- `FlexGrid.padding` parameter
- All Material 3 `ColorScheme` colors via `BuildContext` extensions
- Comprehensive dartdoc documentation

### Changed

- Optimized `humanAge()` calculation
- Switched to `very_good_analysis` linter

### Removed

- `BezierSquircleBorder`

## 1.2.0

- Added `ColorScheme` colors to `BuildContext`
- Added `BezierSquircleBorder`
- Added `StreamWhereType` extension
- Renamed `InputCounterBuilders` → `InputCounterWidgetBuilders`
- Removed `TextStyleFamily`

## 1.1.1

- Added `TickerBuilder.onTick` parameter

## 1.1.0

- Added `TickerBuilder` widget

## 1.0.1

- Updated to new `MediaQuery` lookups
- Removed `elementAtOrNull`, `singleOrNull` (now in core)

## 1.0.0

- Initial release
