import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('setTextAndCaret', () {
    test('caret defaults to end of text', () {
      final c = TextEditingController();
      addTearDown(c.dispose);

      c.setTextAndCaret('hello');

      check(c.text).equals('hello');
      check(c.selection.baseOffset).equals(5);
      check(c.selection.extentOffset).equals(5);
    });

    test('explicit caret honored', () {
      final c = TextEditingController();
      addTearDown(c.dispose);

      c.setTextAndCaret('hello', caret: 0);

      check(c.selection.baseOffset).equals(0);
      check(c.selection.extentOffset).equals(0);
    });

    test('empty string leaves caret at 0', () {
      final c = TextEditingController(text: 'old');
      addTearDown(c.dispose);

      c.setTextAndCaret('');

      check(c.text).equals('');
      check(c.selection.baseOffset).equals(0);
    });

    test('replaces existing text', () {
      final c = TextEditingController(text: 'old');
      addTearDown(c.dispose);

      c.setTextAndCaret('new');

      check(c.text).equals('new');
    });

    test('caret in middle of text', () {
      final c = TextEditingController();
      addTearDown(c.dispose);

      c.setTextAndCaret('abcdef', caret: 3);

      check(c.selection.baseOffset).equals(3);
    });
  });
}
