/// @docImport 'package:flutter/widgets.dart';
library;

import 'dart:async';

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
/// [dispose] runs the closures once: every call returns the same [Future],
/// so a second caller also waits for the release and sees its errors. Adding
/// while [dispose] is in flight runs and awaits the closure as part of that
/// [dispose] call; adding after [dispose] has settled throws [StateError].
/// Calling [dispose] from one of the bag's own disposers, directly or through
/// another bag's disposer, throws [StateError]: it would wait on itself.
final class DisposableBag {
  static final Object _runningKey = Object();

  static Set<DisposableBag> _runningBags() =>
      Zone.current[_runningKey] as Set<DisposableBag>? ?? const {};

  final List<FutureOr<void> Function()> _disposers = [];
  List<(Object, StackTrace)?>? _inFlightSlots;
  List<Future<void>>? _inFlightFutures;
  Completer<void>? _disposal;
  bool _disposed = false;

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposal != null;

  /// Number of registered disposers (or zero after [dispose]).
  int get length => _disposers.length;

  /// Registers [disposer] to run on [dispose]. If [dispose] is in flight,
  /// runs [disposer] as part of it.
  ///
  /// Throws [StateError] if [dispose] has already settled.
  void add(FutureOr<void> Function() disposer) {
    if (_disposed) {
      throw StateError('DisposableBag was used after being disposed.');
    }
    if ((_inFlightSlots, _inFlightFutures) case (
      final slots?,
      final futures?,
    )) {
      _runDisposer(disposer, slots, futures);
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

  void _runDisposer(
    FutureOr<void> Function() disposer,
    List<(Object, StackTrace)?> slots,
    List<Future<void>> futures,
  ) {
    final slotIndex = slots.length;
    slots.add(null);
    try {
      final result = runZoned(
        disposer,
        zoneValues: {
          _runningKey: {..._runningBags(), this},
        },
      );
      if (result is Future) {
        futures.add(
          result.then(
            (_) {},
            onError: (Object e, StackTrace s) => slots[slotIndex] = (e, s),
          ),
        );
      }
    } on Object catch (e, s) {
      slots[slotIndex] = (e, s);
    }
  }

  /// Invokes every registered disposer in order, awaits the ones that return
  /// a [Future] together, then clears the bag. Throws [DisposableBagException]
  /// listing every error in registration order. Every call returns the same
  /// [Future].
  Future<void> dispose() {
    if (_runningBags().contains(this)) {
      throw StateError(
        'DisposableBag.dispose() called from one of its own disposers.',
      );
    }
    if (_disposal case final disposal?) {
      return disposal.future;
    }
    final disposal = Completer<void>();
    _disposal = disposal;
    disposal.complete(_dispose());
    return disposal.future;
  }

  Future<void> _dispose() async {
    final slots = <(Object, StackTrace)?>[];
    final futures = <Future<void>>[];
    _inFlightSlots = slots;
    _inFlightFutures = futures;
    final initial = List<FutureOr<void> Function()>.of(_disposers);
    _disposers.clear();
    for (final disposer in initial) {
      _runDisposer(disposer, slots, futures);
    }
    while (futures.isNotEmpty) {
      final batch = List<Future<void>>.of(futures);
      futures.clear();
      await Future.wait(batch);
    }
    _inFlightSlots = null;
    _inFlightFutures = null;
    _disposed = true;
    final failures = slots.nonNulls.toList();
    if (failures.isNotEmpty) {
      throw DisposableBagException(
        [for (final (e, _) in failures) e],
        stackTraces: [for (final (_, s) in failures) s],
      );
    }
  }
}

/// Exception thrown when one or more disposers throw during
/// [DisposableBag.dispose].
final class DisposableBagException implements Exception {
  /// Creates a [DisposableBagException] with unmodifiable [errors] and
  /// [stackTraces] lists.
  new(List<Object> errors, {List<StackTrace> stackTraces = const []})
    : errors = List.unmodifiable(errors),
      stackTraces = List.unmodifiable(stackTraces);

  /// The errors thrown by individual disposers.
  final List<Object> errors;

  /// Stack traces of [errors], index-aligned; empty when not captured.
  final List<StackTrace> stackTraces;

  @override
  String toString() {
    final count = errors.length;
    final list = errors.map((e) => ' - $e').join('\n');
    return 'DisposableBagException: $count disposer(s) threw errors:\n$list';
  }
}
