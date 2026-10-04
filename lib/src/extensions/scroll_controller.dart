import 'package:flutter/widgets.dart';

/// Position predicates and edge-animation shortcuts for [ScrollController].
///
/// `atTop` / `atBottom` are safe to read before a scrollable attaches —
/// they return `false` when [ScrollController.hasClients] is `false`.
extension ScrollControllerPosition on ScrollController {
  /// `true` when the controller has clients and every attached view is
  /// scrolled to its minimum extent.
  bool get atTop =>
      hasClients && positions.every((p) => p.pixels <= p.minScrollExtent);

  /// `true` when the controller has clients and every attached view is
  /// scrolled to its maximum extent.
  bool get atBottom =>
      hasClients && positions.every((p) => p.pixels >= p.maxScrollExtent);

  /// Animates every attached view to its minimum scroll extent.
  ///
  /// No-op when no client is attached.
  Future<void> animateToTop({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) async {
    await Future.wait([
      for (final p in positions)
        p.animateTo(p.minScrollExtent, duration: duration, curve: curve),
    ]);
  }

  /// Animates every attached view to its maximum scroll extent.
  ///
  /// No-op when no client is attached.
  Future<void> animateToBottom({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) async {
    await Future.wait([
      for (final p in positions)
        p.animateTo(p.maxScrollExtent, duration: duration, curve: curve),
    ]);
  }
}
