part of fluiver;

extension ToFuture<T> on T {
  Future<T> toFuture([Duration? delay]) {
    return delay != null
        ? Future.delayed(delay, () => this)
        : Future.value(this);
  }
}
