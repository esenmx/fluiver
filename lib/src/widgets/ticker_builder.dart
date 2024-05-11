part of '../../fluiver.dart';

class TickerBuilder extends StatefulWidget {
  const TickerBuilder({
    super.key,
    required this.builder,
    this.onTick,
  });

  final Widget Function(BuildContext context, Duration elapsed) builder;
  final void Function(Duration elapsed)? onTick;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final tickerProvider = createTicker((elapsed) {
    setState(() {
      this.elapsed = elapsed;
      widget.onTick?.call(elapsed);
    });
  });
  Duration elapsed = Duration.zero;

  @override
  void initState() {
    tickerProvider.start();
    super.initState();
  }

  @override
  void dispose() {
    tickerProvider.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, elapsed);
  }
}
