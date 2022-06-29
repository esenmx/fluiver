part of fluiver;

mixin _TimerMixin {
  Timer? _timer;

  void dispose() {
    _timer?.cancel();
  }
}

class Debounce with _TimerMixin {
  Debounce(this.duration);

  final Duration duration;

  void call(VoidCallback task) {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    _timer = Timer(duration, task);
  }
}

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
