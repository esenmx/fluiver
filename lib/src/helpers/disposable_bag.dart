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
/// Closures are invoked in registration order. A synchronous disposer
/// completes before the next one starts; disposers that return a [Future]
/// are started in order but awaited together, so [dispose] settles when the
/// slowest one does and a stalled disposer never starves the ones after it.
/// A step that must wait for a previous async step (flush, then close)
/// belongs in one closure: `() async { await flush(); await close(); }`.
/// A disposer that never settles also keeps [dispose] from settling, so
/// errors already collected from other disposers are never reported.
///
/// [dispose] is idempotent — calling it twice runs the closures once. Adding
/// after dispose runs the closure immediately and does not retain it; if
/// that late-added closure throws, the error surfaces as an unhandled async
/// error rather than a [DisposableBagException].
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
      Future.sync(disposer);
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

  /// Invokes every registered disposer in order, awaits the ones that return
  /// a [Future] together, then clears the bag. Throws [DisposableBagException]
  /// listing every error in registration order. Safe to call multiple times.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    final slots = List<Object?>.filled(_disposers.length, null);
    final futures = <Future<void>>[];
    for (var i = 0; i < _disposers.length; i++) {
      try {
        final result = _disposers[i]();
        if (result is Future) {
          futures.add(result.then((_) {}, onError: (Object e) => slots[i] = e));
        }
      } on Object catch (e) {
        slots[i] = e;
      }
    }
    _disposers.clear();
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
    final errors = slots.nonNulls.toList();
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
