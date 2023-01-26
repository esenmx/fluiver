part of fluiver;

///
///
/// ```dart
/// enum Enums with ComparableEnum {
///   one,
///   two,
///   three;
/// }
/// ```
mixin IndexComparableEnum on Enum implements Comparable<Enum> {
  bool operator <(Enum other) => index < other.index;

  bool operator <=(Enum other) => index <= other.index;

  bool operator >(Enum other) => index > other.index;

  bool operator >=(Enum other) => index >= other.index;

  @override
  int compareTo(other) => index - other.index;
}

extension IterableEnumX<T extends Enum> on Iterable<T> {
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
