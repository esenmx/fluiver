part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Filtering [Stream] by type.
extension StreamWhereType<T> on Stream<T> {
  Stream<S> whereType<S>() async* {
    await for (final event in this) {
      if (event is S) {
        yield event;
      }
    }
  }
}
