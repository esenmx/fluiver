import 'package:checks/checks.dart';
import 'package:fluiver/fluiver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _mobilePlatforms = TargetPlatformVariant({.android, .iOS});

const _outsideKey = Key('outside');
const _fieldKey = Key('field');
const _listKey = Key('list');

Widget _outsideBox({
  Key key = _outsideKey,
  double width = 200,
  double height = 100,
}) => Listener(
  key: key,
  behavior: .opaque,
  child: SizedBox(width: width, height: height),
);

FocusNode _managedFocusNode() {
  final node = FocusNode();
  addTearDown(node.dispose);
  return node;
}

Future<void> _focusField(
  WidgetTester tester,
  FocusNode node, {
  Key fieldKey = _fieldKey,
}) async {
  await tester.tap(find.byKey(fieldKey));
  await tester.pump();
  check(node.hasFocus).isTrue;
}

Widget _fieldAboveList(FocusNode focusNode) => UnfocusOnTapOutside(
  child: MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          TextField(key: _fieldKey, focusNode: focusNode),
          Expanded(
            child: ListView.builder(
              key: _listKey,
              itemBuilder: (_, i) => SizedBox(height: 50, child: Text('$i')),
            ),
          ),
        ],
      ),
    ),
  ),
);

class const _StatefulProbe({required final Widget child})
    extends StatefulWidget {
  @override
  State<_StatefulProbe> createState() => _StatefulProbeState();
}

class _StatefulProbeState extends State<_StatefulProbe> {
  @override
  Widget build(BuildContext context) => widget.child;
}

void main() {
  group('UnfocusOnTapOutside', () {
    testWidgets('unfocuses on touch up, not down', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
      );
      await tester.pump();
      check(focusNode.hasFocus).isTrue;

      await gesture.up();
      await tester.pump();
      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('drag past slop and back keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(height: 200),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final origin = tester.getCenter(find.byKey(_outsideKey));
      final gesture = await tester.startGesture(origin);
      await tester.pump();
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('cancelled touch keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 7,
      );
      await tester.pump();
      await gesture.cancel();
      await tester.pump();

      check(focusNode.hasFocus).isTrue;

      final tap = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 7,
      );
      await tester.pump();
      await tap.up();
      await tester.pump();

      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('down outside, up inside field keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(height: 50),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final fieldTopCenter = tester.getRect(find.byKey(_fieldKey)).topCenter;
      final gesture = await tester.startGesture(
        fieldTopCenter - const Offset(0, 30),
        pointer: 9,
      );
      await tester.pump();
      await gesture.moveTo(fieldTopCenter + const Offset(0, 4));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      check(focusNode.hasFocus).isTrue;

      final followUp = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 9,
      );
      await followUp.up();
      await tester.pump();

      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('down inside field, up outside keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(height: 50),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_fieldKey)),
      );
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byKey(_outsideKey)));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('uses MediaQuery gestureSettings touch slop', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                gestureSettings: const DeviceGestureSettings(touchSlop: 50),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(height: 200),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      // 30 px: past the default 18 px touch slop, inside the custom 50 px.
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
      );
      await gesture.moveBy(const Offset(0, 30));
      await gesture.up();
      await tester.pump();

      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('covers pushed routes, dialogs and sheets', (tester) async {
      final routeFocus = _managedFocusNode();
      final dialogFocus = _managedFocusNode();
      final sheetFocus = _managedFocusNode();

      await tester.pumpWidget(
        const UnfocusOnTapOutside(
          child: MaterialApp(home: Scaffold(body: SizedBox.expand())),
        ),
      );
      final navigator = Navigator.of(tester.element(find.byType(Scaffold)))
        ..push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: routeFocus),
                ],
              ),
            ),
          ),
        );
      await tester.pumpAndSettle();
      await _focusField(tester, routeFocus);
      await tester.tap(find.byKey(_outsideKey));
      await tester.pump();
      check(routeFocus.hasFocus).isFalse;

      showDialog<void>(
        context: tester.element(find.byType(Scaffold).last),
        builder: (_) => Dialog(
          child: Column(
            mainAxisSize: .min,
            children: [
              _outsideBox(key: const Key('dialogOut'), width: 150, height: 80),
              TextField(key: const Key('dialogField'), focusNode: dialogFocus),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _focusField(
        tester,
        dialogFocus,
        fieldKey: const Key('dialogField'),
      );
      await tester.tap(find.byKey(const Key('dialogOut')));
      await tester.pump();
      check(dialogFocus.hasFocus).isFalse;

      navigator.pop();
      await tester.pumpAndSettle();

      showModalBottomSheet<void>(
        context: tester.element(find.byType(Scaffold).last),
        builder: (_) => Column(
          mainAxisSize: .min,
          children: [
            _outsideBox(key: const Key('sheetOut'), height: 80),
            TextField(key: const Key('sheetField'), focusNode: sheetFocus),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await _focusField(tester, sheetFocus, fieldKey: const Key('sheetField'));
      await tester.tap(find.byKey(const Key('sheetOut')));
      await tester.pump();
      check(sheetFocus.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('works with WidgetsApp and EditableText', (tester) async {
      final focusNode = _managedFocusNode();
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: WidgetsApp(
            color: const Color(0xFFFFFFFF),
            builder: (_, _) => Column(
              children: [
                _outsideBox(),
                EditableText(
                  key: _fieldKey,
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(),
                  cursorColor: const Color(0xFF000000),
                  backgroundCursorColor: const Color(0xFF888888),
                ),
              ],
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      await tester.tap(find.byKey(_outsideKey));
      await tester.pump();

      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('switching fields moves focus directly', (tester) async {
      final first = _managedFocusNode();
      final second = _managedFocusNode();
      final events = <bool>[];
      first.addListener(() => events.add(first.hasFocus));

      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(key: const Key('first'), focusNode: first),
                  TextField(key: const Key('second'), focusNode: second),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, first, fieldKey: const Key('first'));

      await tester.tap(find.byKey(const Key('second')));
      await tester.pump();

      check(first.hasFocus).isFalse;
      check(second.hasFocus).isTrue;
      check(events).deepEquals([true, false]);
    }, variant: _mobilePlatforms);

    testWidgets('TextFieldTapRegion button keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      var pressed = false;
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Expanded(
                    child: TextField(key: _fieldKey, focusNode: focusNode),
                  ),
                  TextFieldTapRegion(
                    child: ElevatedButton(
                      onPressed: () => pressed = true,
                      child: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      await tester.tap(find.text('Send'));
      await tester.pump();

      check(pressed).isTrue;
      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('plain button unfocuses; requestFocus wins', (tester) async {
      final first = _managedFocusNode();
      final second = _managedFocusNode();
      var plainPressed = false;
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(key: _fieldKey, focusNode: first),
                  TextField(key: const Key('second'), focusNode: second),
                  ElevatedButton(
                    onPressed: () => plainPressed = true,
                    child: const Text('Plain'),
                  ),
                  ElevatedButton(
                    onPressed: second.requestFocus,
                    child: const Text('FocusSecond'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, first);

      await tester.tap(find.text('Plain'));
      await tester.pump();
      check(plainPressed).isTrue;
      check(first.hasFocus).isFalse;

      await _focusField(tester, first);
      await tester.tap(find.text('FocusSecond'));
      await tester.pump();
      check(first.hasFocus).isFalse;
      check(second.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('mouse unfocuses on pointer down', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        kind: .mouse,
      );
      await tester.pump();
      check(focusNode.hasFocus).isFalse;

      await gesture.up();
      await tester.pump();
    }, variant: _mobilePlatforms);

    testWidgets('enabled: false opts a nested subtree out', (tester) async {
      final rootField = _managedFocusNode();
      final nestedField = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: rootField),
                  UnfocusOnTapOutside(
                    enabled: false,
                    child: TextField(
                      key: const Key('nested'),
                      focusNode: nestedField,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await _focusField(tester, rootField);
      await tester.tap(find.byKey(_outsideKey));
      await tester.pump();
      check(rootField.hasFocus).isFalse;

      await _focusField(tester, nestedField, fieldKey: const Key('nested'));
      await tester.tap(find.byKey(_outsideKey));
      await tester.pump();
      check(nestedField.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('disabling mid-touch keeps focus and State', (tester) async {
      final focusNode = _managedFocusNode();
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      Widget buildTree({required bool enabled}) => UnfocusOnTapOutside(
        enabled: enabled,
        child: MaterialApp(
          home: Scaffold(
            body: _StatefulProbe(
              child: Column(
                children: [
                  _outsideBox(),
                  TextField(
                    key: _fieldKey,
                    focusNode: focusNode,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(buildTree(enabled: true));
      final probeState = tester.state(find.byType(_StatefulProbe));
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 5,
      );
      await tester.pumpWidget(buildTree(enabled: false));
      await gesture.up();
      await tester.pump();

      check(tester.state(find.byType(_StatefulProbe))).equals(probeState);
      check(focusNode.hasFocus).isTrue;

      await tester.pumpWidget(buildTree(enabled: true));
      final secondTap = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 5,
      );
      await secondTap.up();
      await tester.pump();
      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('disposing mid-touch throws nothing', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_outsideKey)),
        pointer: 11,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await gesture.moveBy(const Offset(0, 10));
      await gesture.up();
      await tester.pump();

      check(tester.takeException()).isNull;
    }, variant: _mobilePlatforms);

    testWidgets('per-field onTapOutside takes precedence', (tester) async {
      final focusNode = _managedFocusNode();
      var customCalled = false;
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(
                    key: _fieldKey,
                    focusNode: focusNode,
                    onTapOutside: (_) => customCalled = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      await tester.tap(find.byKey(_outsideKey));
      await tester.pump();

      check(customCalled).isTrue;
      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('semantics tap outside unfocuses', (tester) async {
      final focusNode = _managedFocusNode();

      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Semantics(
                    button: true,
                    label: 'Outside Target',
                    child: const SizedBox(width: 200, height: 100),
                  ),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final outsideNode = tester.semantics.find(
        find.bySemanticsLabel('Outside Target'),
      );
      final handler = tester.binding.platformDispatcher.onSemanticsActionEvent;
      check(handler).isNotNull();
      handler?.call(
        SemanticsActionEvent(
          type: .tap,
          nodeId: outsideNode.id,
          viewId: tester.view.viewId,
        ),
      );
      await tester.pump();
      check(focusNode.hasFocus).isFalse;

      await _focusField(tester, focusNode);
      handler?.call(
        SemanticsActionEvent(
          type: .tap,
          nodeId: outsideNode.id,
          viewId: tester.view.viewId,
        ),
      );
      await tester.pump();
      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('touch that stops a fling keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(_fieldAboveList(focusNode));
      await _focusField(tester, focusNode);

      await tester.fling(find.byKey(_listKey), const Offset(0, -400), 3000);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(_listKey));
      await tester.pump();

      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    testWidgets('tap after a fling settles unfocuses', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(_fieldAboveList(focusNode));
      await _focusField(tester, focusNode);

      await tester.fling(find.byKey(_listKey), const Offset(0, -400), 3000);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_listKey));
      await tester.pump();

      check(focusNode.hasFocus).isFalse;
    }, variant: _mobilePlatforms);

    testWidgets('long press outside keeps focus', (tester) async {
      final focusNode = _managedFocusNode();
      await tester.pumpWidget(
        UnfocusOnTapOutside(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  _outsideBox(),
                  TextField(key: _fieldKey, focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );
      await _focusField(tester, focusNode);

      final gesture = await tester.createGesture();
      await gesture.down(tester.getCenter(find.byKey(_outsideKey)));
      await gesture.up(timeStamp: kLongPressTimeout);
      await tester.pump();

      check(focusNode.hasFocus).isTrue;
    }, variant: _mobilePlatforms);

    test('debugFillProperties reports disabled only when false', () {
      final enabledBuilder = DiagnosticPropertiesBuilder();
      const UnfocusOnTapOutside(child: SizedBox())
          .debugFillProperties(enabledBuilder);
      check(enabledBuilder.properties.where((p) => p.name == 'enabled').single)
          .has('description', (p) => p.toDescription())
          .equals('true');

      final disabledBuilder = DiagnosticPropertiesBuilder();
      const UnfocusOnTapOutside(
        enabled: false,
        child: SizedBox(),
      ).debugFillProperties(disabledBuilder);
      check(disabledBuilder.properties.where((p) => p.name == 'enabled').single)
          .has('description', (p) => p.toDescription())
          .equals('disabled');
    });
  });
}
