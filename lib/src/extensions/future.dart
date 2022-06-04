part of fluiver;

extension FutureX<T> on T {
  Future<T> toFuture([Duration? delay]) {
    return delay != null
        ? Future.delayed(delay, () => this)
        : Future.value(this);
  }
}
