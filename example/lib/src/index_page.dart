import 'package:example/src/flex_grid_page.dart';
import 'package:example/src/ticker_builder_page.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('FlexGrid'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const FlexGridPage();
              },
            )),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('TickerBuilder'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const TickerBuilderPage();
              },
            )),
          ),
        ],
      ),
    );
  }
}
