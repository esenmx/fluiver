import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';

class TickerBuilderPage extends StatelessWidget {
  const TickerBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker Builder Page'),
      ),
      body: Center(
        child: TickerBuilder(
          builder: (context, elapsed) {
            return Text(
              elapsed.inSeconds.toString(),
              style: context.headlineLargeTextStyle,
            );
          },
        ),
      ),
    );
  }
}
