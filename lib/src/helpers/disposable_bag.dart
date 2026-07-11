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
      final _ = Future.sync(disposer);
      return;
    }
    _disposers.add(disposer);
  }

  /// Registers each closure in [disposers]. Convenience for bulk-add — same
  /// semantics as calling [add] in order.
  ///
  /// ```dart
  /// final bag = DisposableBag()
  ///   ..addAll([
  ///     debounce.dispose,
  ///     subscription.cancel,
  ///     controller.dispose,
  ///   ]);
  /// ```
  void addAll(Iterable<FutureOr<void> Function()> disposers) {
    disposers.forEach(add);
  }

  /// Runs every registered disposer in order, then clears the bag.
  /// Safe to call multiple times.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    final errors = <Object>[];
    for (final disposer in _disposers) {
      try {
        await disposer();
      } on Object catch (e) {
        errors.add(e);
      }
    }
    _disposers.clear();
    if (errors.isNotEmpty) {
      throw DisposableBagException(errors);
    }
  }
}

/// Exception thrown when one or more disposers throw during
/// [DisposableBag.dispose].
class DisposableBagException implements Exception {
  /// Creates a [DisposableBagException] with the list of errors.
  DisposableBagException(this.errors);

  /// The errors thrown by individual disposers.
  final List<Object> errors;

  @override
  String toString() {
    final count = errors.length;
    final list = errors.map((e) => ' - $e').join('\n');
    return 'DisposableBagException: $count disposer(s) threw errors:\n$list';
  }
}
