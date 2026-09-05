import 'package:example/src/index_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: IndexPage());
  }
}
