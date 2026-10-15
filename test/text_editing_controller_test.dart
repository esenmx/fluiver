import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter_test/flutter_test.dart';

import '_helpers.dart';

void main() {
  group('setTextAndCaret', () {
    test('caret defaults to end of text', () {
      final c = newTextEditingController()..setTextAndCaret('hello');

      check(c.text).equals('hello');
      check(c.selection.baseOffset).equals(5);
      check(c.selection.extentOffset).equals(5);
    });

    test('explicit caret honored', () {
      final c = newTextEditingController()..setTextAndCaret('hello', caret: 0);

      check(c.selection.baseOffset).equals(0);
      check(c.selection.extentOffset).equals(0);
    });

    test('empty string leaves caret at 0', () {
      final c = newTextEditingController(text: 'old')..setTextAndCaret('');

      check(c.text).equals('');
      check(c.selection.baseOffset).equals(0);
    });

    test('replaces existing text', () {
      final c = newTextEditingController(text: 'old')..setTextAndCaret('new');

      check(c.text).equals('new');
    });

    test('caret in middle of text', () {
      final c = newTextEditingController()..setTextAndCaret('abcdef', caret: 3);

      check(c.selection.baseOffset).equals(3);
    });

    test('caret at length is the end', () {
      final c = newTextEditingController()..setTextAndCaret('hello', caret: 5);

      check(c.selection.baseOffset).equals(5);
      check(c.selection.extentOffset).equals(5);
    });

    test('caret outside 0..length throws RangeError and keeps the value', () {
      for (final caret in const [-5, -1, 6, 10]) {
        final c = newTextEditingController()..setTextAndCaret('before');
        check(
          because: '$caret',
          () => c.setTextAndCaret('hello', caret: caret),
        ).throws<RangeError>().has((e) => e.name, 'name').equals('caret');
        check(because: '$caret', c.text).equals('before');
      }
    });
  });
}
