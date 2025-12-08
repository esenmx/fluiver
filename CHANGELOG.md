# Changelog

## 2.2.0

Removed these methods since they are already in `package:collection`.
Here removed methods and their equivalents in `package:collection`:

- `Iterable<Widget>.slicedWidgetsBuilder` => Use `Iterable.groupListsBy` instead.
- `Iterable.firstWhereOrNull`, `Iterable.lastWhereOrNull`, `Iterable.whereNot` => Use `Iterable.firstWhereOrNull`, `Iterable.lastWhereOrNull`, `Iterable.whereNot` instead.
- `Iterable.groupAsMap` => Use `Iterable.groupFoldBy`, `Iterable.groupListsBy`, `Iterable.groupSetsBy`
- `Iterable.to2D` => Use `Iterable.slices`
- `Iterable.earliest`, `Iterable.latest` => Use `Iterable.minBy` and `Iterable.maxBy`
- `Iterable<num>.sum`, `Iterable<num>.average`, `Iterable<num>.lowest`, `Iterable<num>.highest` => Use `Iterable<num>.sum`, `Iterable<num>.average`, `Iterable<num>.min`, `Iterable<num>.max`
- `Iterable<Iterable>.flatten` => `Iterable<Iterable>.flattened`, `Iterable<Iterable>.flattenedToList`, `Iterable<Iterable>.flattenedToSet`
- `Iterable.sliced` => Use `Iterable.skip()` + `Iterable.take()` combination instead.
- `List.safeSubList` => Use `Iterable.skip()` + `Iterable.take()` combination instead.
- `Set.subSet` => Use `Iterable.skip()` + `Iterable.take() + .toSet()` combination instead.

Renamed these methods:

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
