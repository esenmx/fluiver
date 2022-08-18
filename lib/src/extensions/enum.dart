part of fluiver;

extension IterableEnum<T extends Enum> on Iterable<T> {
  T? byNameOrNull(String name) {
    for (var e in this) {
      if (e.name == name) {
        return e;
      }
    }
    return null;
  }

  T byNameOrElse(String name, {T Function()? orElse}) {
    for (var e in this) {
      if (e.name == name) {
        return e;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('no element found, consider using orElse()');
  }

  List<String> names() => map<String>((e) => e.name).toList();
}
