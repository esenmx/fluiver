part of fluiver;

/// ref: https://twitter.com/vandadnp/status/1513361193662128130/photo/1
extension WithDelay<T> on T {
  Future<T> toFuture([Duration? delay]) =>
      delay != null ? Future.delayed(delay, () => this) : Future.value(this);
}