import 'package:example/src/grid_page.dart';
import 'package:example/src/ticker_builder_page.dart';
import 'package:flutter/material.dart';

class const IndexPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('Grid'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const GridPage();
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('TickerBuilder'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const TickerBuilderPage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
