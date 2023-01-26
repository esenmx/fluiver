import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

enum Dump with IndexComparableEnum {
  foo,
  bar,
  baz;
}

void main() async {
  test('ComparableEnum', () {
    expect(Dump.foo > Dump.bar, isFalse);
    expect(Dump.bar > Dump.foo, isTrue);

    expect(Dump.foo >= Dump.bar, isFalse);
    expect(Dump.bar >= Dump.bar, isTrue);
    expect(Dump.baz >= Dump.bar, isTrue);

    expect(Dump.bar < Dump.foo, isFalse);
    expect(Dump.foo < Dump.bar, isTrue);

    expect(Dump.foo <= Dump.bar, isTrue);
    expect(Dump.bar <= Dump.bar, isTrue);
    expect(Dump.baz <= Dump.bar, isFalse);

    final unordered = [Dump.baz, Dump.foo, Dump.bar];
    expect(unordered..sort(), orderedEquals(Dump.values));
  });
}
