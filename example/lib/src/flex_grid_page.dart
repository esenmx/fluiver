import 'package:fluiver/fluiver.dart';
import 'package:flutter/material.dart';

class FlexGridPage extends StatefulWidget {
  const FlexGridPage({super.key});

  @override
  State<FlexGridPage> createState() => _FlexGridPageState();
}

class _FlexGridPageState extends State<FlexGridPage> {
  int _crossAxisCount = 2;
  double _mainAxisSpacing = 16;
  double _crossAxisSpacing = 16;
  double _aspectRatio = 2;
  double _paddingLeft = 16;
  double _paddingTop = 16;
  double _paddingRight = 16;
  double _paddingBottom = 16;

  EdgeInsets get _padding => EdgeInsets.only(
        left: _paddingLeft,
        top: _paddingTop,
        right: _paddingRight,
        bottom: _paddingBottom,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlexGrid'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'FlexGrid Controls',
                      style: context.titleLargeTextStyle,
                    ),
                    const SizedBox(height: 24),
                    IncrementalControl(
                      label: 'Cross Axis Count',
                      value: _crossAxisCount.toDouble(),
                      step: 1,
                      min: 1,
                      onChanged: (value) =>
                          setState(() => _crossAxisCount = value.toInt()),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Main Axis Spacing',
                      value: _mainAxisSpacing,
                      step: 1,
                      min: 0,
                      onChanged: (value) =>
                          setState(() => _mainAxisSpacing = value),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Cross Axis Spacing',
                      value: _crossAxisSpacing,
                      step: 1,
                      min: 0,
                      onChanged: (value) =>
                          setState(() => _crossAxisSpacing = value),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Aspect Ratio',
                      value: _aspectRatio,
                      step: 0.1,
                      min: 0.1,
                      onChanged: (value) =>
                          setState(() => _aspectRatio = value),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Padding',
                      style: context.titleMediumTextStyle,
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Left',
                      value: _paddingLeft,
                      step: 1,
                      min: 0,
                      onChanged: (value) =>
                          setState(() => _paddingLeft = value),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Top',
                      value: _paddingTop,
                      step: 1,
                      min: 0,
                      onChanged: (value) => setState(() => _paddingTop = value),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Right',
                      value: _paddingRight,
                      step: 1,
                      min: 0,
                      onChanged: (value) =>
                          setState(() => _paddingRight = value),
                    ),
                    const SizedBox(height: 16),
                    IncrementalControl(
                      label: 'Bottom',
                      value: _paddingBottom,
                      step: 1,
                      min: 0,
                      onChanged: (value) =>
                          setState(() => _paddingBottom = value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FlexGrid(
                crossAxisCount: _crossAxisCount,
                mainAxisSpacing: _mainAxisSpacing,
                crossAxisSpacing: _crossAxisSpacing,
                childAspectRatio: _aspectRatio,
                padding: _padding,
                direction: Axis.vertical,
                children: [
                  for (var i = 0; i < 100; i++)
                    Container(
                      color: Colors.primaries[i % Colors.primaries.length],
                      alignment: Alignment.center,
                      child: Text(
                        i.toString(),
                        style: context.displayMediumTextStyle,
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IncrementalControl extends StatelessWidget {
  const IncrementalControl({
    super.key,
    required this.label,
    required this.value,
    required this.step,
    required this.min,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double step;
  final double min;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            label,
            style: context.bodyMediumTextStyle,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > min
                  ? () => onChanged((value - step).clamp(min, double.infinity))
                  : null,
              style: IconButton.styleFrom(
                backgroundColor: value > min ? null : Colors.grey.shade200,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
                textAlign: TextAlign.center,
                style: context.bodyLargeTextStyle,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + step),
            ),
          ],
        )
      ],
    );
  }
}
