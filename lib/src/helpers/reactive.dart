part of '../../fluiver.dart';

/// Mixin for managing timer lifecycle.
mixin _TimerMixin {
  Timer? _timer;

  void dispose() {
    _timer?.cancel();
  }
}

/// Debounces function calls, executing only after a delay period.
class Debounce with _TimerMixin {
  Debounce(this.duration);

  final Duration duration;

  void call(VoidCallback task) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(duration, task);
  }
}

/// Throttles function calls, executing immediately and queuing the latest call.
class ThrottleLatest with _TimerMixin {
  ThrottleLatest(this.duration);

  final Duration duration;
  VoidCallback? _pending;

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

/// Throttles function calls, executing only the first call within a time period.
class ThrottleFirst with _TimerMixin {
  ThrottleFirst(this.duration);

  final Duration duration;

  void call(VoidCallback task) {
    if (_timer?.isActive != true) {
      task.call();
      _timer = Timer(duration, () {});
    }
  }
}

/// Throttles function calls, executing only the last call after a delay.
class ThrottleLast with _TimerMixin {
  ThrottleLast(this.duration);

  final Duration duration;
  late VoidCallback _last;

  void call(VoidCallback task) {
    _last = task;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, () => _last());
    }
  }
}
