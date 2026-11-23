# fluiver extensions

- **DateTime**: `isToday()`, `isTomorrow()`, `isYesterday()`, `inThisYear()`, `isWithinFromNow(Duration)` (`ArgumentError` if negative), `age({at})` (full years from stored calendar fields, no TZ conversion; `at` defaults to local now; call `.toLocal()` on UTC-stored local dates), `truncateTime()` (-> midnight, preserves UTC). No arithmetic helpers — use stdlib `Duration`.
- **TimeOfDay**: `tod.onDate(date)` -> `DateTime` on that calendar day (`package:material_ui/material_ui.dart` `TimeOfDay`). Pass day explicitly for deterministic tests.
- **Enum**: `with EnumIndexComparable<MyEnum>` adds `<`/`>`/`compareTo` by index. `values.byNameOrNull(name)` -> nullable for untrusted input (stdlib `byName` throws); chain `?? .fallback`.
- **Iterable**: `intersperse((i) => sep)` (index-aware builder, unlike `collection.separated(value)`); `slidingWindows(size, {step})` (Kotlin `windowed`; **drops partial trailing window**, vs non-overlapping `collection.slices`).
- **Map**: `where` over `(k, v)`; `whereKeyType<T>()`, `whereValueType<T>()` (narrowed static type); `entryOf(key)` -> `MapEntry?`, null **only when absent** (present-with-null != missing).
- **Object.into** (`T extends Object`, Kotlin `let`): transform-and-return; `?.into(...)` null-aware (`env['PORT']?.into(int.parse)`). Skip for side-effect-only, multi-line bodies, or chains >3.
- **Color** (HSL): `darken([amount])`, `lighten([amount])` (default ±0.1; `RangeError` outside `[0, 1]`), `contrastText()` (higher-contrast black/white). All three throw `ArgumentError` if any channel is outside `[0, 1]` (gamut-map extended sRGB first).
- **ScrollController**: `atTop()`, `atBottom()`, `animateToTop({duration, curve})`, `animateToBottom(...)` — throw `StateError` when unattached (check `hasClients`); `atTop()`/`atBottom()` require every attached view at edge; `animateTo*` throw `ArgumentError` unless `duration` is positive.
- **Future**: `timeoutOrNull(Duration)` -> `Future<T?>` (null on timeout **only**; underlying errors still throw; non-nullable `Future<T>` only; `ArgumentError` if negative).
- **TextEditingController**: `setTextAndCaret(text, {caret})` — sets text + valid caret whether focused or not (`.text =` sets invalid offset -1; focused fields repair to end on mobile/multiline or select-all on single-line desktop); `RangeError` if `caret` outside `0..text.length`.
