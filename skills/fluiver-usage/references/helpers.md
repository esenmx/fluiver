# fluiver helpers

|API|Contract|
|-|-|
|`FastHash.fnv1a(String)` -> `int`|FNV-1a-64 over UTF-16BE code units (!= UTF-8 FNV-1a). **Throws on JS web**; VM/Wasm fine. Non-cryptographic.|
|`NetworkProbe.checkConnection({host, port, timeout})`|`false` on `SocketException`/`TimeoutException`. Defaults `1.0.0.1:53`, 3s; `host` = literal IP. Negative `timeout` -> `ArgumentError`. Web -> `UnsupportedError`.|
|`NetworkProbe.isBrowserOnline()`|Web `navigator.onLine` (`false` = known offline); non-web -> `UnsupportedError`.|
|`platformDispatch<T>({android, ios, macos, web, ...})`|Per-platform value (lowercase params); throws `UnsupportedError` when current platform callback omitted.|
|`TextFieldBuilders.disabledCounter`|`TextField(buildCounter: TextFieldBuilders.disabledCounter)` hides counter.|
|`LRUCache<K, V>(maxEntries:)`|O(1) get/put, promotes to MRU; per-isolate. For async, use `LRUCache<K, Future<V>>` to dedupe concurrent misses. `peek(key)` reads without promoting; `keys`/`values`/`entries` are snapshots.|
|`DisposableBag()`|`..add(fn)`/`..addAll([...])`; `dispose()` runs all once (re-calls return same future), then throws `DisposableBagException` if any failed; `add` after settle or `dispose()` from own disposer -> `StateError`. Async disposers start in registration order and await together (put dependent steps in one closure). Pair with `ref.onDispose(bag.dispose)`.|
