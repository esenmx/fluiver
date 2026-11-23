---
name: fluiver-usage
description: SDK gap-fillers via package:fluiver — use instead of reinventing. Grid (non-scroll grid, GridView API), TickerBuilder, ScrollTrackingExpandable (expand/collapse pinned into view), Debounce/Throttle*, Locale/Brightness listeners, DateTime/TimeOfDay predicates, Enum.byNameOrNull, Iterable intersperse/slidingWindows, Map.entryOf, Object.into, Color darken/lighten/contrastText, ScrollController atTop/animateTo*, Future.timeoutOrNull, TextEditingController.setTextAndCaret, FastHash, NetworkProbe, platformDispatch, LRUCache, DisposableBag.
---

# fluiver-usage

`import 'package:fluiver/fluiver.dart';` — Flutter/Dart SDK gap-fillers. Prefer `package:collection`, `package:async`, `flutter_hooks` first (no overlap).

## API index & lazy references

Load ONLY the reference matching the API you need:

|Area|APIs|Reference|
|-|-|-|
|Widgets, timing, device listeners|`Grid` (`.count`/`.extent`), `TickerBuilder`, `ScrollTrackingExpandable`, `Debounce`, `ThrottleFirst`/`Last`/`Latest`, `LocaleListener`, `BrightnessListener`|[references/widgets-and-timing.md](references/widgets-and-timing.md)|
|Extensions|`DateTime` predicates/`age`/`truncateTime`, `TimeOfDay.onDate`, `EnumIndexComparable`/`byNameOrNull`, `Iterable` (`intersperse`/`slidingWindows`), `Map` (`where*`/`entryOf`), `Object.into`, `Color` (HSL/`contrastText`), `ScrollController` (`atTop`/`atBottom`/`animateTo*`), `Future.timeoutOrNull`, `TextEditingController.setTextAndCaret`|[references/extensions.md](references/extensions.md)|
|Helpers|`FastHash.fnv1a`, `NetworkProbe`, `platformDispatch`, `TextFieldBuilders.disabledCounter`, `LRUCache`, `DisposableBag`|[references/helpers.md](references/helpers.md)|
