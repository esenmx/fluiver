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
  TimeFormat _selectedFormat = TimeFormat.full;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    return switch (_selectedFormat) {
      TimeFormat.microseconds => duration.inMicroseconds.toString(),
      TimeFormat.milliseconds => duration.inMilliseconds.toString(),
      TimeFormat.seconds => duration.inSeconds.toString(),
      TimeFormat.minutes => duration.inMinutes.toString(),
      TimeFormat.hours => duration.inHours.toString(),
      TimeFormat.days => duration.inDays.toString(),
      TimeFormat.full =>
        DateFormat('HH:mm:ss.SSS').format(DateTime(0).add(duration)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker Builder Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TickerBuilder(
            builder: (context, elapsed) {
              final formattedValue = _formatDuration(elapsed);
              _controller.value = TextEditingValue(
                text: formattedValue,
                selection:
                    TextSelection.collapsed(offset: formattedValue.length),
              );
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      readOnly: true,
                      style: context.headlineLargeTextStyle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Ticker Value',
                        hintText: '00:00:00.000',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<TimeFormat>(
                    segments: const [
                      ButtonSegment(
                        value: TimeFormat.full,
                        label: Text('Full'),
                        tooltip: 'HH:mm:ss.SSS',
                      ),
                      ButtonSegment(
                        value: TimeFormat.microseconds,
                        label: Text('μs'),
                        tooltip: 'Microseconds',
                      ),
                      ButtonSegment(
                        value: TimeFormat.milliseconds,
                        label: Text('ms'),
                        tooltip: 'Milliseconds',
                      ),
                      ButtonSegment(
                        value: TimeFormat.seconds,
                        label: Text('s'),
                        tooltip: 'Seconds',
                      ),
                      ButtonSegment(
                        value: TimeFormat.minutes,
                        label: Text('m'),
                        tooltip: 'Minutes',
                      ),
                      ButtonSegment(
                        value: TimeFormat.hours,
                        label: Text('h'),
                        tooltip: 'Hours',
                      ),
                      ButtonSegment(
                        value: TimeFormat.days,
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
