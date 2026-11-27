/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Unfocuses the active text field on outside touch taps without interfering
/// with scrolling, dragging, or gesture disambiguation.
///
/// Place it around the app (e.g. wrapping [MaterialApp] or `CupertinoApp`) to
/// cover every route, dialog and modal sheet, or around a single screen or
/// form. Set [enabled] to `false` on a nested [UnfocusOnTapOutside] to opt a
/// subtree back out to Flutter's default [EditableText] behavior.
///
/// ```dart
/// const UnfocusOnTapOutside(
///   child: MaterialApp(home: MyHomePage()),
/// );
/// ```
///
/// How it behaves:
///
/// * **Touch** (`PointerDeviceKind.touch`): waits for pointer up and unfocuses
///   only if the pointer never moved past touch slop, was not cancelled, and
///   was held for less than [kLongPressTimeout]. Scrolls, drags, edge swipes,
///   long presses, and a touch that stops a moving scrollable (a fling or
///   `animateTo`) leave the keyboard alone.
/// * **Mouse, stylus and other pointers**: delegates to Flutter's default
///   [EditableTextTapOutsideIntent] action (unfocuses on pointer down).
/// * **Companion controls**: switching between text fields, tapping
///   [InputDecoration] icons, selection handles, context menus, or
///   [Autocomplete] options stays focused via [TextFieldTapRegion]. Wrap any
///   external control that should keep the keyboard open (such as a chat send
///   button) in [TextFieldTapRegion].
/// * **Per-field override**: any [EditableText], [TextField], or
///   `CupertinoTextField` that provides its own `onTapOutside` or
///   `onTapUpOutside` takes precedence.
class const UnfocusOnTapOutside({
  /// The subtree whose text fields unfocus on outside touch taps.
  required final Widget child,

  /// Whether outside touch taps unfocus focused text fields in [child].
  ///
  /// When `false`, outside taps fall back to Flutter's default [EditableText]
  /// behavior, overriding any enclosing [UnfocusOnTapOutside].
  final bool enabled = true,
  super.key,
}) extends StatefulWidget {
  /// Creates an [UnfocusOnTapOutside].
  this;

  @override
  State<UnfocusOnTapOutside> createState() => _UnfocusOnTapOutsideState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty('enabled', value: enabled, ifFalse: 'disabled'),
    );
  }
}

typedef _TrackedPointer = ({
  Offset origin,
  double slopSquared,
  Duration timeStamp,
});

class _UnfocusOnTapOutsideState extends State<UnfocusOnTapOutside> {
  final Map<int, _TrackedPointer> _pointers = {};
  var _scrollJustStopped = false;

  late final Map<Type, Action<Intent>> _actions = {
    EditableTextTapOutsideIntent:
        _OverridingAction<EditableTextTapOutsideIntent>(_onTapOutside),
    EditableTextTapUpOutsideIntent:
        _OverridingAction<EditableTextTapUpOutsideIntent>(_onTapUpOutside),
  };

  bool _onTapOutside(
    EditableTextTapOutsideIntent intent,
    BuildContext? invocationContext,
  ) {
    if (!widget.enabled) return false;
    final event = intent.pointerDownEvent;
    if (event.kind != .touch) return false;
    // RenderTapRegionSurface._handleSemanticsAction synthesizes a touch
    // PointerDownEvent with pointer == 0 and timeStamp == Duration.zero, with
    // no matching PointerUpEvent or PointerRouter delivery.
    if (event.pointer == 0 && event.timeStamp == .zero) {
      intent.focusNode.unfocus();
      return true;
    }
    if (_scrollJustStopped) return true;
    // Read MediaQuery from EditableText's invocation context without
    // registering a rebuild dependency; also works when this widget wraps
    // MaterialApp above MediaQuery.
    final gestureSettings = invocationContext
        ?.getInheritedWidgetOfExactType<MediaQuery>()
        ?.data
        .gestureSettings;
    final slop = computeHitSlop(event.kind, gestureSettings);
    final pointer = event.pointer;
    if (!_pointers.containsKey(pointer)) {
      GestureBinding.instance.pointerRouter.addRoute(pointer, _onPointerEvent);
    }
    _pointers[pointer] = (
      origin: event.position,
      slopSquared: slop * slop,
      timeStamp: event.timeStamp,
    );
    return true;
  }

  bool _onTapUpOutside(EditableTextTapUpOutsideIntent intent, BuildContext? _) {
    if (!widget.enabled) return false;
    final event = intent.pointerUpEvent;
    final tracked = _pointers[event.pointer];
    if (tracked == null) return false;
    _dropPointer(event.pointer);
    final isTap =
        (event.position - tracked.origin).distanceSquared <=
            tracked.slopSquared &&
        event.timeStamp - tracked.timeStamp < kLongPressTimeout;
    if (isTap) intent.focusNode.unfocus();
    return true;
  }

  // A touch that stops a fling or `animateTo` ends the scroll synchronously
  // (Scrollable's drag-down hold), before the tap-outside intent of the same
  // PointerDownEvent; the microtask clears the flag once that dispatch is over.
  bool _onScrollEnd(ScrollEndNotification notification) {
    if (!_scrollJustStopped) {
      _scrollJustStopped = true;
      scheduleMicrotask(() => _scrollJustStopped = false);
    }
    return false;
  }

  void _onPointerEvent(PointerEvent event) {
    final tracked = _pointers[event.pointer];
    if (tracked == null) return;
    switch (event) {
      case PointerMoveEvent(:final position):
        if ((position - tracked.origin).distanceSquared > tracked.slopSquared) {
          _dropPointer(event.pointer);
        }
      case PointerUpEvent() || PointerCancelEvent():
        _dropPointer(event.pointer);
      default:
        break;
    }
  }

  void _dropPointer(int pointer) {
    if (_pointers.remove(pointer) != null) {
      GestureBinding.instance.pointerRouter.removeRoute(
        pointer,
        _onPointerEvent,
      );
    }
  }

  void _clearPointers() {
    for (final pointer in _pointers.keys) {
      GestureBinding.instance.pointerRouter.removeRoute(
        pointer,
        _onPointerEvent,
      );
    }
    _pointers.clear();
  }

  @override
  void dispose() {
    _clearPointers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: _actions,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: _onScrollEnd,
        child: widget.child,
      ),
    );
  }
}

class _OverridingAction<T extends Intent>(
  final bool Function(T intent, BuildContext? context) _onInvoke,
) extends ContextAction<T> {
  @override
  void invoke(T intent, [BuildContext? context]) {
    if (!_onInvoke(intent, context)) {
      switch (callingAction) {
        case final ContextAction<T> action:
          action.invoke(intent, context);
        case final Action<T> action:
          action.invoke(intent);
        default:
          break;
      }
    }
  }
}
