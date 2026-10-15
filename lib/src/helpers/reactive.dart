import 'dart:async';

import 'package:flutter/foundation.dart';

/// Mixin for managing timer lifecycle.
mixin _TimerMixin {
  Timer? _timer;
  bool _disposed = false;

  void _checkDuration(Duration duration) {
    if (duration < Duration.zero) {
      throw ArgumentError.value(duration, 'duration', 'must not be negative');
    }
  }

  void _checkNotDisposed() {
    if (_disposed) {
      throw StateError('$runtimeType was used after being disposed.');
    }
  }

  /// Cancels any pending task. The object must not be used afterwards.
  void dispose() {
    _disposed = true;
    _timer?.cancel();
  }
}

/// Debounces function calls — runs the task only after [duration] of
/// silence since the last invocation.
final class Debounce(
  /// The quiet period required before the latest task fires.
  final Duration duration,
) with _TimerMixin {
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
    _timer = Timer(duration, task);
  }
}

/// Throttles function calls — runs the first call immediately, then runs
/// the latest queued call once the window expires.
final class ThrottleLatest(
  /// The cooldown window between emissions.
  final Duration duration,
) with _TimerMixin {
  /// Creates a throttler with the given cooldown [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }
  VoidCallback? _pending;

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

  @override
  void dispose() {
    _pending = null;
    super.dispose();
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
) with _TimerMixin {
  /// Creates a throttler with the given trailing-window [duration].
  ///
  /// Throws [ArgumentError] if [duration] is negative.
  this {
    _checkDuration(duration);
  }
  VoidCallback? _last;

  /// Stores [task] as the latest, scheduling it to run after [duration]
  /// if no run is already pending.
  ///
  /// Throws [StateError] if called after [dispose].
  void call(VoidCallback task) {
    _checkNotDisposed();
    _last = task;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, () {
        final task = _last;
        _last = null;
        task?.call();
      });
    }
  }

  @override
  void dispose() {
    _last = null;
    super.dispose();
  }
}
