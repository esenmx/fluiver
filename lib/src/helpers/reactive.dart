part of '../../fluiver.dart';

/// Mixin for managing timer lifecycle.
mixin _TimerMixin {
  Timer? _timer;

  void dispose() {
    _timer?.cancel();
  }
}

/// Debounces function calls — runs the task only after [duration] of
/// silence since the last invocation.
class Debounce with _TimerMixin {
  /// Creates a debouncer with the given quiet-period [duration].
  Debounce(this.duration);

  /// The quiet period required before the latest task fires.
  final Duration duration;

  /// Schedules [task] to run after [duration]; replaces any pending task.
  void call(VoidCallback task) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(duration, task);
  }
}

/// Throttles function calls — runs the first call immediately, then runs
/// the latest queued call once the window expires.
class ThrottleLatest with _TimerMixin {
  /// Creates a throttler with the given cooldown [duration].
  ThrottleLatest(this.duration);

  /// The cooldown window between emissions.
  final Duration duration;
  VoidCallback? _pending;

  /// Runs [task] immediately if no window is active, otherwise queues it
  /// as the latest pending task.
  void call(VoidCallback task) {
    if (_timer?.isActive != true) {
      task.call();
      _timer = Timer(duration, () {
        if (_pending != null) {
          _pending!.call();
          _pending = null;
        }
      });
    } else {
      _pending = task;
    }
  }
}

/// Throttles function calls — runs only the first call within each
/// [duration] window; subsequent calls are ignored.
class ThrottleFirst with _TimerMixin {
  /// Creates a throttler with the given cooldown [duration].
  ThrottleFirst(this.duration);

  /// The cooldown window during which subsequent calls are dropped.
  final Duration duration;

  /// Runs [task] immediately if no window is active, otherwise drops it.
  void call(VoidCallback task) {
    if (_timer?.isActive != true) {
      task.call();
      _timer = Timer(duration, () {});
    }
  }
}

/// Throttles function calls — waits [duration], then runs only the most
/// recent call.
class ThrottleLast with _TimerMixin {
  /// Creates a throttler with the given trailing-window [duration].
  ThrottleLast(this.duration);

  /// The trailing window before the latest task fires.
  final Duration duration;
  late VoidCallback _last;

  /// Stores [task] as the latest, scheduling it to run after [duration]
  /// if no run is already pending.
  void call(VoidCallback task) {
    _last = task;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, () => _last());
    }
  }
}
