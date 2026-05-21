import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextFieldBuilders.disabledCounter', () {
    testWidgets('returns null so TextField renders no counter', (tester) async {
      Widget? built;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                built = TextFieldBuilders.disabledCounter(
                  context,
                  currentLength: 5,
                  maxLength: 10,
                  isFocused: true,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      check(built).isNull();
    });

    testWidgets('hides counter when wired into TextField', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              maxLength: 10,
              buildCounter: TextFieldBuilders.disabledCounter,
              controller: TextEditingController(text: 'abc'),
            ),
          ),
        ),
      );

      // Default counter renders as "3/10"; with disabledCounter no such text.
      check(find.text('3/10').evaluate()).isEmpty();
    });
  });
}
