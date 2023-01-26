import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  group('int', () {
    test('sum', () {
      expect(<int>[].sum(), 0);
      expect([1].sum(), 1);
      expect([1, 2, 3].sum(), 6);
      expect(List.generate(100, (i) => i).sum(), 99 * (99 + 1) / 2);
    });

    test('lowest', () {
      expect(() => <int>[].lowest, throwsA(isA<StateError>()));
      expect([1].lowest, 1);
      expect([1, 2, 3].lowest, 1);
      expect([1, 2, -1].lowest, -1);
    });
  });

  group('double', () {
    test('sum', () {
      expect(<double>[].sum(), 0.0);
      expect([1.1].sum(), 1.1);
      expect([1.1, 2.2, 3.3].sum(), 6.6);
      expect(
        List<double>.generate(100, (i) => i.toDouble()).sum(),
        (99 * (99 + 1) / 2).toDouble(),
      );
    });

    test('lowest', () {
      expect(() => <double>[].lowest, throwsA(isA<StateError>()));
      expect(<double>[1].lowest, 1);
      expect(<double>[1, 2, 3].lowest, 1);
      expect(<double>[1, 2, -1].lowest, -1);
    });
  });
}
