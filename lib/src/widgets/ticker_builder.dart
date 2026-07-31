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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<void Function(Duration elapsed)>.has('onTick', onTick),
    );
  }
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;

  Duration elapsed = .zero;

  void handleTick(Duration tick) {
    setState(() {
      elapsed = tick;
    });
    widget.onTick?.call(tick);
  }

  @override
  void initState() {
    super.initState();
    ticker = createTicker(handleTick);
    ticker.start();
  }

  @override
  void dispose() {
    // Before super: the ticker-provider mixin asserts no live ticker remains.
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, elapsed);
  }
}
