part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Position predicates and edge-animation shortcuts for [ScrollController].
///
/// `atTop` / `atBottom` are safe to read before a scrollable attaches —
/// they return `false` when [ScrollController.hasClients] is `false`.
extension ScrollControllerPosition on ScrollController {
  /// `true` when the controller has clients and is scrolled to the
  /// minimum extent.
  bool get atTop {
    if (!hasClients) {
      return false;
    }
    return position.pixels <= position.minScrollExtent;
  }

  /// `true` when the controller has clients and is scrolled to the
  /// maximum extent.
  bool get atBottom {
    if (!hasClients) {
      return false;
    }
    return position.pixels >= position.maxScrollExtent;
  }

  /// Animates to the minimum scroll extent.
  ///
  /// No-op when no client is attached.
  Future<void> animateToTop({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) async {
    if (!hasClients) {
      return;
    }
    await animateTo(
      position.minScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates to the maximum scroll extent.
  ///
  /// No-op when no client is attached.
  Future<void> animateToBottom({
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) async {
    if (!hasClients) {
      return;
    }
    await animateTo(
      position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }
}
