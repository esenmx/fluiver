part of fluiver;

extension ToFutureX<T> on T {
  Future<T> toFuture([Duration? delay]) {
    return delay != null
        ? Future.delayed(delay, () => this)
        : Future.value(this);
  }
}
