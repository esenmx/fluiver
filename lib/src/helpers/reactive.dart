part of fluiver;

class Debounce {
  Debounce(this.duration);

  final Duration duration;
  Timer? _timer;

  void call(VoidCallback task) {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    _timer = Timer(duration, task);
  }

  void dispose() {
    _timer?.cancel();
  }
}
