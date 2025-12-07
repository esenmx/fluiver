# Changelog

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
