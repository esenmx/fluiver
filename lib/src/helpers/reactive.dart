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

class ThrottleLast with _TimerMixin {
  ThrottleLast(this.duration);

  final Duration duration;
  late VoidCallback _last;

  void call(VoidCallback task) {
    _last = task;
    if (_timer?.isActive != true) {
      _timer = Timer(duration, _last);
    }
  }
}
