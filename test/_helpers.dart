import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds [value], registers [dispose] as a test `tearDown`, returns [value].
///
/// Collapses the three-line `final c = X(); addTearDown(c.dispose); … c` to
/// a single expression.
T autoDispose<T>(T value, FutureOr<void> Function() dispose) {
  addTearDown(dispose);
  return value;
}

/// `ScrollController()` with `dispose()` already scheduled for `tearDown`.
ScrollController newScrollController() {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  return controller;
}

/// `TextEditingController(text: text)` with `dispose()` already scheduled.
TextEditingController newTextEditingController({String? text}) {
  final controller = TextEditingController(text: text);
  addTearDown(controller.dispose);
  return controller;
}

/// Pumps a vertical `ListView` of fixed-extent items wired to [controller].
Future<void> pumpScrollableList(
  WidgetTester tester,
  ScrollController controller, {
  int itemCount = 100,
  double itemExtent = 50,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          controller: controller,
          itemCount: itemCount,
          itemBuilder: (_, i) => SizedBox(
            height: itemExtent,
            child: Text('$i'),
          ),
        ),
      ),
    ),
  );
}
