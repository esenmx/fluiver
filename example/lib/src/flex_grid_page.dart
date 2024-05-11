import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';

class FlexGridPage extends StatelessWidget {
  const FlexGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: FlexGrid(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2,
          direction: Axis.vertical,
          children: [
            for (var i = 0; i < 100; i++)
              Container(
                color: Colors.primaries[i % Colors.primaries.length],
                alignment: Alignment.center,
                child: Text(
                  i.toString(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              )
          ],
        ),
      ),
    );
  }
}
