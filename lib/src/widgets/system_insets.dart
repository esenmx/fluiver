/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'dart:math' as math;

import 'package:fluiver/src/extensions/color.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Pads [child] by the view insets (the on-screen keyboard) that no ancestor
/// has consumed, and removes them below so nothing pads twice.
///
/// Use it where the keyboard would cover content and nothing has lifted it
/// yet: modal bottom sheet content, the body of a
/// `Scaffold(resizeToAvoidBottomInset: false)` without a bottom bar or with
/// `extendBody: true`, or an input bar in `Scaffold.bottomNavigationBar`. Where
/// an ancestor already lifted its content (a resizing [Scaffold] body, a
/// [Dialog], another [ViewInsetsPadding]) it pads nothing, so a reusable form
/// is safe anywhere.
///
/// ```dart
/// showModalBottomSheet<void>(
///   context: context,
///   isScrollControlled: true,
///   builder: (context) => const ViewInsetsPadding(
///     child: SafeArea(top: false, child: TextField()),
///   ),
/// );
/// ```
///
/// [child] still sees the home-indicator padding the keyboard leaves
/// uncovered, so a [SafeArea] inside it adds exactly that.
///
/// Traps it can't detect:
///
/// * Without `isScrollControlled: true` a modal sheet is capped at 9/16 of the
///   screen height and the lifted content overflows (reported in debug only).
/// * `SafeArea(maintainBottomViewPadding: true)` belongs inside it; outside, it
///   leaves a gap the height of the home indicator.
/// * In [Scaffold.bottomSheet] of a resizing [Scaffold] it pads twice: that
///   slot is already lifted above the keyboard but still reports it.
/// * In the body of a `Scaffold(resizeToAvoidBottomInset: false)` that has a
///   `bottomNavigationBar`, it pads the bar height twice: the body ends at the
///   bar but still reports the keyboard from the screen bottom. Add
///   `extendBody: true` (with a [SafeArea] inside it) or let the [Scaffold]
///   resize.
///
/// Throws [StateError] when it builds without a [MediaQuery] ancestor.
class const ViewInsetsPadding({
  /// The widget lifted above the keyboard.
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  /// Creates a [ViewInsetsPadding].
  this;

  @override
  Widget build(BuildContext context) {
    final data =
        MediaQuery.maybeOf(context) ??
        (throw StateError('ViewInsetsPadding needs a MediaQuery ancestor'));
    final insets = data.viewInsets;
    // padding is net of the keyboard at the root but gross when a Scaffold
    // slot or bar raises it.
    double below(double padding, double viewPadding, double inset) => inset > 0
        ? math.max(0, math.max(padding, viewPadding) - inset)
        : padding;
    return Padding(
      padding: insets,
      child: MediaQuery(
        data: data
            .removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
            )
            .copyWith(
              padding: EdgeInsets.fromLTRB(
                below(data.padding.left, data.viewPadding.left, insets.left),
                below(data.padding.top, data.viewPadding.top, insets.top),
                below(data.padding.right, data.viewPadding.right, insets.right),
                below(
                  data.padding.bottom,
                  data.viewPadding.bottom,
                  insets.bottom,
                ),
              ),
            ),
        child: child,
      ),
    );
  }
}

/// Status-bar-only [SystemUiOverlayStyle]s, equal to what a Material 3
/// `AppBar` derives; for `AppBar.systemOverlayStyle` and [AnnotatedRegion].
/// Nav-bar fields stay null.
///
/// Unlike [SystemUiOverlayStyle.light] and [SystemUiOverlayStyle.dark], which
/// also paint the Android navigation bar black with light icons, these leave
/// the navigation bar alone. Each sets both status-bar fields: iOS reads
/// `statusBarBrightness` (the background), Android `statusBarIconBrightness`
/// (the icons).
///
/// ```dart
/// final appBar = AppBar(systemOverlayStyle: StatusBarIcons.light);
/// ```
abstract final class StatusBarIcons {
  /// Light icons, for dark backgrounds (iOS and Android).
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// Dark icons, for light backgrounds.
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}

/// An opaque header for screens without an AppBar: paints [color] behind the
/// status bar, pads [child] below it, and sets status-bar icons that contrast
/// [color].
///
/// Place it where it reaches the status bar: first in the [Column] of a
/// [Scaffold] body without `appBar`, or as the first sliver through
/// [SliverToBoxAdapter]. It is as wide as [child], so give it the full width:
/// `crossAxisAlignment: .stretch` in a [Column]. Side cutouts then pad [child]
/// while [color] fills them.
///
/// ```dart
/// Scaffold(
///   body: Column(
///     crossAxisAlignment: .stretch,
///     children: [
///       StatusBarHeader(color: Colors.indigo, child: Text('Profile')),
///     ],
///   ),
/// );
/// ```
///
/// The icons follow [ColorTransform.contrastText]: light over a color that
/// white text contrasts best, dark otherwise. A mid-tone such as
/// `Colors.blue` gets dark icons where an [AppBar] of that color gets light
/// ones. For a gradient, image or blur, compose an [AnnotatedRegion] of
/// [StatusBarIcons], a [DecoratedBox] and `SafeArea(bottom: false)`.
///
/// Traps it can't detect: placed below other content, it neither paints behind
/// the status bar nor sets its icons; narrower than the screen, it misses the
/// screen center where the icons are read; around a [Scaffold] that has an
/// [AppBar], the AppBar's icons win.
///
/// Throws [ArgumentError] when [color] isn't opaque or has a channel outside
/// `[0, 1]`, and [StateError] when the status bar is shown but an ancestor
/// already consumed its inset (a [SafeArea], an [AppBar], a [ListView]'s
/// automatic padding, a modal bottom sheet route). Both happen when it builds,
/// because the constructor is `const`.
class const StatusBarHeader({
  /// The opaque background, painted behind the status bar too.
  required final Color color,

  /// The header content, laid out below the status bar.
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  /// Creates a [StatusBarHeader].
  this;

  @override
  Widget build(BuildContext context) {
    if (color.a != 1) {
      throw ArgumentError.value(color, 'color', 'must be opaque');
    }
    final icons = color.contrastText == const Color(0xFFFFFFFF)
        ? StatusBarIcons.light
        : StatusBarIcons.dark;
    if (View.of(context).padding.top > 0 &&
        MediaQuery.paddingOf(context).top == 0) {
      throw StateError(
        'StatusBarHeader found the status bar inset already consumed by an '
        'ancestor (SafeArea, AppBar, ListView padding or a modal sheet); '
        'place it first in a Scaffold body without appBar, or as the first '
        'sliver.',
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: icons,
      child: ColoredBox(
        color: color,
        child: SafeArea(bottom: false, child: child),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}
