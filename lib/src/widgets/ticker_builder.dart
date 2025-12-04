part of '../../fluiver.dart';

/// A widget that rebuilds on each tick, providing elapsed [Duration].
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({
    required this.builder,
    super.key,
    this.onTick,
  });

  final Widget Function(BuildContext context, Duration elapsed) builder;
  final void Function(Duration elapsed)? onTick;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker tickerProvider = createTicker((elapsed) {
    setState(() {
      this.elapsed = elapsed;
      widget.onTick?.call(elapsed);
    });
  });
  Duration elapsed = Duration.zero;

  @override
  void initState() {
    unawaited(tickerProvider.start());
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
