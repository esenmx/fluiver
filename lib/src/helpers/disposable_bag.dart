part of '../../fluiver.dart';

/// Collects disposers and flushes them with a single [dispose] call.
///
/// Pattern: register `dispose()` / `cancel()` / `close()` closures from
/// every resource (debounce, stream subscription, timer, controller) into
/// one bag, then dispose the bag in [State.dispose] / `ref.onDispose`.
///
/// ```dart
/// final bag = DisposableBag()
///   ..add(debounce.dispose)
///   ..add(subscription.cancel)
///   ..add(controller.dispose);
/// // ...
/// bag.dispose();
/// ```
///
/// Closures run in registration order. [dispose] is idempotent — calling it
/// twice runs the closures once. Adding after dispose runs the closure
/// immediately and does not retain it.
class DisposableBag {
  final List<FutureOr<void> Function()> _disposers = [];
  bool _disposed = false;

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposed;

  /// Number of registered disposers (or zero after [dispose]).
  int get length => _disposers.length;

  /// Registers [disposer] to run on [dispose]. If the bag is already
  /// disposed, runs [disposer] immediately.
  void add(FutureOr<void> Function() disposer) {
    if (_disposed) {
      unawaited(Future.sync(disposer));
      return;
    }
    _disposers.add(disposer);
  }

  /// Runs every registered disposer in order, then clears the bag.
  /// Safe to call multiple times.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    for (final disposer in _disposers) {
      await disposer();
    }
    _disposers.clear();
  }
}
