import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// A widget that rebuilds on every frame, providing the elapsed running
/// [Duration]: time since the first frame, minus any time spent disabled.
///
/// Owns a [Ticker] internally; starts it in `initState` and stops it in
/// `dispose`. Drop in when you need per-frame rebuilds (e.g. a countdown
/// or a debug clock) without managing the ticker yourself.
///
/// Set [enabled] to `false` to pause, e.g. once a countdown ends, so nothing
/// rebuilds and `pumpAndSettle` settles.
class const TickerBuilder({
  /// Called every frame with the elapsed running time (time spent disabled
  /// excluded).
  required final Widget Function(BuildContext context, Duration elapsed)
  builder,

  /// Optional side-effect callback invoked every frame alongside [builder].
  final void Function(Duration elapsed)? onTick,

  /// Whether the ticker runs. While `false` no frames are scheduled and the
  /// elapsed time holds; re-enabling resumes from it.
  final bool enabled = true,
  super.key,
}) extends StatefulWidget {
  /// Creates a widget that rebuilds every frame.
  this;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<void Function(Duration elapsed)>.has(
          'onTick',
          onTick,
        ),
      )
      ..add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;

  Duration elapsed = .zero;

  Duration resumedFrom = .zero;

  void handleTick(Duration tick) {
    setState(() {
      elapsed = resumedFrom + tick;
    });
    widget.onTick?.call(elapsed);
  }

  @override
  void initState() {
    super.initState();
    ticker = createTicker(handleTick);
    if (widget.enabled) {
      ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant TickerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled == oldWidget.enabled) {
      return;
    }
    if (widget.enabled) {
      resumedFrom = elapsed;
      ticker.start();
    } else {
      ticker.stop();
    }
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
