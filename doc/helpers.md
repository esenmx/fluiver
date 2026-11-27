# Helpers

## Debounce / Throttle

```dart
// dispose() it with its owner, e.g. in State.dispose.
final debounce = Debounce(const Duration(milliseconds: 300));

Widget searchField(ValueChanged<String> search) {
  return TextField(onChanged: (query) => debounce(() => search(query)));
}
```

| Variant | Fires |
| --- | --- |
| `Debounce` | once calls stop for the duration (autosave; search-as-you-type together with `LatestOnly`) |
| `ThrottleFirst` | the first call, then drops calls until the window ends (submit, anti rage-click) |
| `ThrottleLast` | the last call made during the window, when it ends (scroll position save, slider end) |
| `ThrottleLatest` | the first call at once, then the latest call of each window as it ends (live preview) |

All four are callable, throw `ArgumentError` for a negative duration, expose
`dispose()`, and throw `StateError` if called or disposed again after disposal.

`dispose()` drops a task that is still waiting. `Debounce`, `ThrottleLast` and
`ThrottleLatest` can hold one: `flush()` runs it now, so an autosave keeps its
last edit; `cancel()` drops it and keeps the object; `isPending` tells whether
one is waiting.

```dart
final autosave = Debounce(const Duration(seconds: 2));

void closeEditor() {
  autosave
    ..flush()
    ..dispose();
}
```

## `LatestOnly`

A debounce alone doesn't stop a slow old response from replacing a newer one.
`LatestOnly` delivers only the newest call's result: a superseded call, or one
still running at `dispose()`, returns `null`.

```dart
final debounce = Debounce(const Duration(milliseconds: 300));
final latest = LatestOnly();

void onQueryChanged(
  String query,
  Future<List<String>> Function(String query) search,
  void Function(List<String> hits) show,
) {
  debounce(() async {
    final hits = await latest(() => search(query));
    if (hits != null) show(hits);
  });
}
```

The superseded request keeps running; only its result, or its error, is
dropped. The newest call's error is thrown, so catch it inside the debounced
closure. Results must be non-nullable, so `null` always means superseded.

## `LRUCache`

```dart
final cache = LRUCache<String, DateTime>(maxEntries: 100);

// Lazy on miss; a hit promotes the entry to most-recently-used.
DateTime parse(String iso) => cache.putIfAbsent(iso, () => DateTime.parse(iso));

cache['epoch'] = DateTime.utc(1970);
final hit = cache['epoch']; // promotes to most-recent
final peeked = cache.peek('epoch'); // no promotion
// keys, values and entries are snapshots, least-recently-used first
for (final MapEntry(:key, :value) in cache.entries) {
  debugPrint('$key: $value');
}
```

For async loads, type it `LRUCache<K, Future<V>>` so concurrent misses share one
future.

## `DisposableBag`

```dart
final debounce = Debounce(const Duration(milliseconds: 300));
final controller = TextEditingController();
final subscription = Stream<void>.periodic(const Duration(seconds: 1))
    .listen((_) => debugPrint('tick'));

final bag = DisposableBag()
  ..add(debounce.dispose)
  ..addAll([subscription.cancel, controller.dispose]);
// Once, from State.dispose or ref.onDispose:
await bag.dispose();
```

Async disposers start in registration order but are awaited together; dependent
steps (flush, then close) go in one closure. Every `dispose()` call returns the
same future; `add` after it settled throws `StateError`.

## Listeners

These wrappers fill the gap for providers — non-widget code that holds a
device-state listenable. Like the framework's `AppLifecycleListener`, each one
registers itself on construction and stops on `dispose()`. In a widget, use
`flutter_hooks`' `useOnPlatformBrightnessChange` for brightness; `flutter_hooks`
ships no locale hook, so mix `WidgetsBindingObserver` into the `State` for
locales.

```dart
final locales = ValueNotifier<List<Locale>?>(
  WidgetsBinding.instance.platformDispatcher.locales,
);
final listener = LocaleListener((next) => locales.value = next);
// Call listener.dispose() when the owner goes away.
```

In a Riverpod notifier, create the listener in `build()` with
`(locales) => state = locales`, register `ref.onDispose(listener.dispose)`, and
return `PlatformDispatcher.instance.locales`. Same shape for
`BrightnessListener`. App lifecycle needs no wrapper — the framework's
`AppLifecycleListener` already is one.

## Network, hashing, platform, TextField

```dart
// Native only (TCP); throws UnsupportedError on web.
// A negative timeout throws ArgumentError everywhere.
if (await NetworkProbe.checkConnection()) {
  debugPrint('online');
}
// Web only; false only when the browser knows it is offline.
if (NetworkProbe.isBrowserOnline()) {
  debugPrint('not known to be offline');
}

// FNV-1a-64 over UTF-16BE code units (≠ FNV-1a over UTF-8).
// Throws on JS web; VM and Wasm are fine.
final hash = FastHash.fnv1a('input');

final storeUrl = platformDispatch<String>(
  android: () =>
      'https://play.google.com/store/apps/details?id=com.example.app',
  ios: () => 'https://apps.apple.com/app/id123456789',
);

const field = TextField(buildCounter: TextFieldBuilders.disabledCounter);
```
