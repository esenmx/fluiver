part of '../../fluiver.dart';

/// A widget that rebuilds on each tick, providing elapsed [Duration].
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({
    required this.builder,
    this.onTick,
    super.key,
  });

  final Widget Function(BuildContext context, Duration elapsed) builder;
  final void Function(Duration elapsed)? onTick;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((elapsed) {
    setState(() {
      this.elapsed = elapsed;
      widget.onTick?.call(elapsed);
    });
  });
  Duration elapsed = Duration.zero;

  @override
  void initState() {
    unawaited(_ticker.start());
    super.initState();
  }

  @override
  void dispose() {
    _ticker.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, elapsed);
  }
}
