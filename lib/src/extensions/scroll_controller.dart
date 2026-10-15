import 'package:flutter/widgets.dart';

/// Position predicates and edge-animation shortcuts for [ScrollController].
///
/// Like [ScrollController.position], every member throws [StateError] when
/// [ScrollController.hasClients] is `false`; check it first when the
/// controller may not be attached yet.
extension ScrollControllerPosition on ScrollController {
  /// `true` when every attached view is scrolled to its minimum extent.
  ///
  /// Throws [StateError] when no scroll view is attached.
  bool atTop() {
    _checkAttached();
    return positions.every((p) => p.pixels <= p.minScrollExtent);
  }

  /// `true` when every attached view is scrolled to its maximum extent.
  ///
  /// Throws [StateError] when no scroll view is attached.
  bool atBottom() {
    _checkAttached();
    return positions.every((p) => p.pixels >= p.maxScrollExtent);
  }

  /// Animates every attached view to its minimum scroll extent.
  ///
  /// Throws [StateError] when no scroll view is attached.
  Future<void> animateToTop({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) {
    _checkAttached();
    return Future.wait([
      for (final p in positions)
        p.animateTo(p.minScrollExtent, duration: duration, curve: curve),
    ]);
  }

  /// Animates every attached view to its maximum scroll extent.
  ///
  /// Throws [StateError] when no scroll view is attached.
  Future<void> animateToBottom({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) {
    _checkAttached();
    return Future.wait([
      for (final p in positions)
        p.animateTo(p.maxScrollExtent, duration: duration, curve: curve),
    ]);
  }

  void _checkAttached() {
    if (!hasClients) {
      throw StateError('ScrollController not attached to any scroll views.');
    }
  }
}
