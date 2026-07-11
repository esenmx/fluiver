part of '../../fluiver.dart';

/// A widget that rebuilds on every frame, providing the elapsed [Duration]
/// since the first frame.
///
/// Owns a [Ticker] internally; starts it in `initState` and stops it in
/// `dispose`. Drop in when you need per-frame rebuilds (e.g. a countdown
/// or a debug clock) without managing the ticker yourself.
class TickerBuilder extends StatefulWidget {
  /// Creates a widget that rebuilds every frame.
  const TickerBuilder({required this.builder, this.onTick, super.key});

  /// Called every frame with the elapsed time since the first frame.
  final Widget Function(BuildContext context, Duration elapsed) builder;

  /// Optional side-effect callback invoked every frame alongside [builder].
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

  /// Elapsed time since the first frame; updated every tick.
  Duration elapsed = .zero;

  @override
  void initState() {
    super.initState();
    final _ = _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, elapsed);
  }
}
