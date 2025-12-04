import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Iterable<int>', () {
    group('sum', () {
      test('empty', () => check(<int>[].sum()).equals(0));
      test('single', () => check([1].sum()).equals(1));
      test('multiple', () => check([1, 2, 3].sum()).equals(6));
      test('formula', () {
        check(List.generate(100, (i) => i).sum()).equals(99 * 100 ~/ 2);
      });
    });

    group('lowest', () {
      test('empty throws', () {
        check(() => <int>[].lowest()).throws<StateError>();
      });
      test('single', () => check([1].lowest()).equals(1));
      test('positive', () => check([1, 2, 3].lowest()).equals(1));
      test('negative', () => check([1, 2, -1].lowest()).equals(-1));
    });

    group('highest', () {
      test('empty throws', () {
        check(() => <int>[].highest()).throws<StateError>();
      });
      test('single', () => check([1].highest()).equals(1));
      test('multiple', () => check([1, 2, 3].highest()).equals(3));
    });
  });

  group('Iterable<double>', () {
    group('sum', () {
      test('empty', () => check(<double>[].sum()).equals(0));
      test('single', () => check([1.1].sum()).equals(1.1));
      test('multiple', () => check([1.1, 2.2, 3.3].sum()).equals(6.6));
    });

    group('lowest', () {
      test('empty throws', () {
        check(() => <double>[].lowest()).throws<StateError>();
      });
      test('positive', () => check(<double>[1, 2, 3].lowest()).equals(1));
      test('negative', () => check(<double>[1, 2, -1].lowest()).equals(-1));
    });

    group('average', () {
      test('single', () => check([2.0].average()).equals(2));
      test('multiple', () => check([1.0, 2.0, 3.0].average()).equals(2));
    });
  });
}
