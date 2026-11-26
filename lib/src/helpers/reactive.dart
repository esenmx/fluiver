import 'dart:async';

import 'package:flutter/foundation.dart';

/// Mixin for managing timer lifecycle.
mixin _TimerMixin {
  Timer? _timer;
  bool _disposed = false;

  void _checkDuration(Duration duration) {
    if (duration < .zero) {
      throw ArgumentError.value(duration, 'duration', 'must not be negative');
    }
  }

  void _checkNotDisposed() {
    if (_disposed) {
      throw StateError('$runtimeType was used after being disposed.');
    }
  }

  /// Cancels any pending task. The object must not be used afterwards.
  ///
  /// Throws [StateError] if called a second time.
  void dispose() {
    _checkNotDisposed();
    _disposed = true;
    _timer?.cancel();
  }
}

/// Mixin for helpers that hold one waiting task behind their timer.
mixin _PendingTaskMixin on _TimerMixin {
  VoidCallback? _pending;

  /// Whether a task is waiting to run. `false` after [dispose].
  bool get isPending => _pending != null;

  /// Runs the waiting task now instead of when its timer ends. Does nothing
  /// when no task is waiting.
  ///
  /// Throws [StateError] if called after [dispose].
  void flush() {
    _take()?.call();
  }

  /// Drops the waiting task without running it; the object stays usable.
  ///
  /// Throws [StateError] if called after [dispose].
  void cancel() {
    _take();
  }

  VoidCallback? _take() {
    _checkNotDisposed();
    _timer?.cancel();
    final task = _pending;
    _pending = null;
    return task;
  }

  /// Drops any waiting task. The object must not be used afterwards.
  ///
  /// Throws [StateError] if called a second time.
  @override
  void dispose() {
    _pending = null;
    super.dispose();
  }
}

/// Debounces function calls — runs the task only after [duration] of
/// silence since the last invocation.
///
/// [dispose] drops a task that is still waiting. To keep it, as an autosave
/// must keep the last edit, [flush] first:
///
/// ```dart
/// final autosave = Debounce(const Duration(seconds: 2));
///
/// void close() {
///   autosave
///     ..flush()
///     ..dispose();
/// }
/// ```
final class Debounce(
  /// The quiet period required before the latest task fires.
  final Duration duration,
) with _TimerMixin, _PendingTaskMixin {
  /// Creates a debouncer with the given quiet-period [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }

  /// Schedules [task] to run after [duration]; replaces any pending task.
  ///
  /// Throws [StateError] if called after [dispose].
  void call(VoidCallback task) {
    _checkNotDisposed();
    _timer?.cancel();
    _pending = task;
    _timer = Timer(duration, flush);
  }
}

/// Throttles function calls — runs the first call immediately, then runs
/// the latest queued call once the window expires.
final class ThrottleLatest(
  /// The cooldown window between emissions.
  final Duration duration,
) with _TimerMixin, _PendingTaskMixin {
  /// Creates a throttler with the given cooldown [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }

  void _onTimerComplete() {
    if (_pending case final task?) {
      _pending = null;
      _timer = Timer(duration, _onTimerComplete);
      task();
    }
  }

  /// Runs [task] immediately if no window is active, otherwise queues it
  /// as the latest pending task.
  ///
  /// Throws [StateError] if called after [dispose].
  void call(VoidCallback task) {
    _checkNotDisposed();
    if (_timer?.isActive != true) {
      _timer = Timer(duration, _onTimerComplete);
      task();
    } else {
      _pending = task;
    }
  }

  /// Runs the queued task now and starts a new window from it. Does nothing
  /// when no task is queued; the current window keeps running.
  ///
  /// Throws [StateError] if called after [dispose].
  @override
  void flush() {
    _checkNotDisposed();
    if (isPending) {
      _timer?.cancel();
      _onTimerComplete();
    }
  }

  /// Drops the queued task without running it; the current window keeps
  /// running.
  ///
  /// Throws [StateError] if called after [dispose].
  @override
  void cancel() {
    _checkNotDisposed();
    _pending = null;
  }
}

/// Throttles function calls — runs only the first call within each
/// [duration] window; subsequent calls are ignored.
final class ThrottleFirst(
  /// The cooldown window during which subsequent calls are dropped.
  final Duration duration,
) with _TimerMixin {
  /// Creates a throttler with the given cooldown [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }

  /// Runs [task] immediately if no window is active, otherwise drops it.
  ///
  /// Throws [StateError] if called after [dispose].
  void call(VoidCallback task) {
    _checkNotDisposed();
    if (_timer?.isActive != true) {
      _timer = Timer(duration, () {});
      task();
    }
  }
}

/// Throttles function calls — waits [duration], then runs only the most
/// recent call.
final class ThrottleLast(
  /// The trailing window before the latest task fires.
  final Duration duration,
) with _TimerMixin, _PendingTaskMixin {
  /// Creates a throttler with the given trailing-window [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }

  /// Stores [task] as the latest, scheduling it to run after [duration]
  /// if no run is already pending.
  ///
  /// Throws [StateError] if called after [dispose].
  void call(VoidCallback task) {
    _checkNotDisposed();
    _pending = task;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, flush);
    }
  }
}

/// Delivers only the newest call's outcome: when the same request is started
/// again before it answers, the older answer is dropped, so a slow old
/// response can't replace a newer one (search-as-you-type).
///
/// ```dart
/// final debounce = Debounce(const Duration(milliseconds: 300));
/// final latest = LatestOnly();
///
/// void onChanged(String query) {
///   debounce(() async {
///     final hits = await latest(() => api.search(query));
///     if (hits != null) setState(() => results = hits);
///   });
/// }
/// ```
///
/// [dispose] drops the answer of a call that is still running, so the
/// `null` check also covers a disposed owner. The superseded work itself
/// keeps running; only its outcome is dropped.
final class LatestOnly {
  int _generation = 0;
  bool _disposed = false;

  /// Runs [run] and returns its result, or `null` when a newer call started
  /// or [dispose] ran before it answered. An error from such a superseded
  /// run is dropped as well; an error from the newest run is thrown.
  ///
  /// Only for non-nullable results, so `null` always means superseded.
  ///
  /// Throws [StateError] if called after [dispose].
  Future<T?> call<T extends Object>(Future<T> Function() run) {
    _checkNotDisposed();
    return _deliver(run, ++_generation);
  }

  Future<T?> _deliver<T extends Object>(
    Future<T> Function() run,
    int generation,
  ) async {
    try {
      final result = await run();
      return generation == _generation ? result : null;
    } on Object {
      if (generation == _generation) rethrow;
      return null;
    }
  }

  void _checkNotDisposed() {
    if (_disposed) {
      throw StateError('LatestOnly was used after being disposed.');
    }
  }

  /// Drops the outcome of any running call. The object must not be used
  /// afterwards.
  ///
  /// Throws [StateError] if called a second time.
  void dispose() {
    _checkNotDisposed();
    _disposed = true;
    _generation++;
  }
}
