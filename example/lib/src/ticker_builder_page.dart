import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TickerBuilderPage extends StatefulWidget {
  const TickerBuilderPage({super.key});

  @override
  State<TickerBuilderPage> createState() => _TickerBuilderPageState();
}

class _TickerBuilderPageState extends State<TickerBuilderPage> {
  final TextEditingController _controller = TextEditingController();
  TimeFormat _selectedFormat = .full;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    return switch (_selectedFormat) {
      .microseconds => duration.inMicroseconds.toString(),
      .milliseconds => duration.inMilliseconds.toString(),
      .seconds => duration.inSeconds.toString(),
      .minutes => duration.inMinutes.toString(),
      .hours => duration.inHours.toString(),
      .days => duration.inDays.toString(),
      .full => DateFormat('HH:mm:ss.SSS').format(DateTime(0).add(duration)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticker Builder Page')),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          TickerBuilder(
            builder: (context, elapsed) {
              final formattedValue = _formatDuration(elapsed);
              _controller.value = TextEditingValue(
                text: formattedValue,
                selection: .collapsed(offset: formattedValue.length),
              );
              return Column(
                mainAxisAlignment: .center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: _controller,
                      textAlign: .center,
                      readOnly: true,
                      style: Theme.of(context).textTheme.headlineLarge,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: .circular(8)),
                        labelText: 'Ticker Value',
                        hintText: '00:00:00.000',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<TimeFormat>(
                    segments: const [
                      ButtonSegment(
                        value: .full,
                        label: Text('Full'),
                        tooltip: 'HH:mm:ss.SSS',
                      ),
                      ButtonSegment(
                        value: .microseconds,
                        label: Text('μs'),
                        tooltip: 'Microseconds',
                      ),
                      ButtonSegment(
                        value: .milliseconds,
                        label: Text('ms'),
                        tooltip: 'Milliseconds',
                      ),
                      ButtonSegment(
                        value: .seconds,
                        label: Text('s'),
                        tooltip: 'Seconds',
                      ),
                      ButtonSegment(
                        value: .minutes,
                        label: Text('m'),
                        tooltip: 'Minutes',
                      ),
                      ButtonSegment(
                        value: .hours,
                        label: Text('h'),
                        tooltip: 'Hours',
                      ),
                      ButtonSegment(
                        value: .days,
                        label: Text('d'),
                        tooltip: 'Days',
                      ),
                    ],
                    selected: {_selectedFormat},
                    onSelectionChanged: (Set<TimeFormat> newSelection) {
                      setState(() {
                        _selectedFormat = newSelection.first;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

enum TimeFormat {
  full,
  microseconds,
  milliseconds,
  seconds,
  minutes,
  hours,
  days,
}
