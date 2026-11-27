# Widgets

## `Grid` — non-scrolling grid

`GridView`'s layout without its viewport — configured by the same
`SliverGridDelegate` family, with `Grid.count` / `Grid.extent` mirroring
`GridView.count` / `GridView.extent` 1:1. The drop-in for
`GridView(shrinkWrap: true)` inside `ListView` / `SingleChildScrollView`: no
repaint boundaries, no scroll semantics, and intrinsics/dry layout actually work
(a shrink-wrapped `GridView` throws inside `IntrinsicHeight`).

```dart
final featured = ListView(
  children: [
    const Text('Featured'),
    Grid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [for (var i = 0; i < 6; i++) Text('Product $i')],
    ),
  ],
);
```

Every constructor also takes `direction:` (the main axis) and `padding:`. Use
`GridView` when the grid itself scrolls (viewport recycling matters).

`Grid.count` and `Grid.extent` throw `ArgumentError` for a count, ratio or
maximum extent that isn't positive, and for spacing or `mainAxisExtent` that is
negative or not finite. A negative `padding` reports one when the grid builds.
Cells too big for a bounded box are clipped to it, and debug builds report the
overflow and paint the striped indicator.

## `TickerBuilder`

Rebuilds every frame, exposes the elapsed running `Duration` (time spent
disabled excluded; time muted by an ancestor `TickerMode` still counts).

```dart
Widget stopwatch({required bool done}) {
  return TickerBuilder(
    enabled: !done,
    builder: (context, elapsed, _) => Text('${elapsed.inSeconds}s'),
  );
}
```

`enabled: false` pauses it — no frames, `elapsed` held — e.g. once a countdown
ends. For per-frame side effects, pass `onTick` and keep `builder` pure. Pass
the part that doesn't change as `child`: `builder` gets it back every frame as
its third argument, built once.

## `ScrollTrackingExpandable`

Expand/collapse with a size animation that keeps the growing bottom edge visible
in the nearest `Scrollable` — an expanding tile near the bottom of a list no
longer overflows below the fold.

```dart
Widget shippingDetails({required bool expanded}) {
  return ScrollTrackingExpandable(
    isExpanded: expanded,
    // Extra breathing room below the bottom edge.
    scrollOffset: 16,
    child: const Text('Ships in 2–4 days. Free returns within 30 days.'),
  );
}
```

Collapse never scrolls; only expansion tracks. If there is no enclosing
`Scrollable`, the size animation still runs without scroll tracking. A negative
`duration` reports an `ArgumentError` when the widget builds.

## Insets: keyboard and status bar

The keyboard covers the fields of a bottom sheet. A form padded by
`MediaQuery.viewInsetsOf` pads twice under a resizing `Scaffold`, or leaves a
34px gap above the keyboard. A header color stops below the status bar, and the
status-bar icons stay white on a white screen. These three pieces get each case
right on iOS and Android.

`ViewInsetsPadding` lifts its child above the keyboard and tells everything
below that it did, so nothing pads twice:

```dart
Future<void> rename(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    // Without it the sheet stops at 9/16 of the screen: a long form overflows.
    isScrollControlled: true,
    builder: (context) => const ViewInsetsPadding(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: .min,
          children: [Text('Rename'), TextField(autofocus: true)],
        ),
      ),
    ),
  );
}
```

It pads nothing where a `Scaffold` already resized for the keyboard, so a
reusable form is safe in a sheet, a page or a dialog. On a `Scaffold` that
doesn't resize and has a `bottomNavigationBar`, add `extendBody: true`, or it
pads the bar height twice. A chat composer goes in the bottom bar slot and rides
the keyboard, resizing `Scaffold` or not:

```dart
Widget chat(Widget messages, Widget composer) {
  return Scaffold(
    body: messages,
    bottomNavigationBar: ViewInsetsPadding(child: composer),
  );
}
```

`StatusBarHeader` is a colored header for a screen without an `AppBar`: the
color reaches behind the status bar, the child sits below it, and the status-bar
icons contrast the color:

```dart
Widget profile(String name) {
  return Scaffold(
    body: Column(
      children: [
        StatusBarHeader(
          color: Colors.indigo,
          child: Padding(
            padding: const .all(16),
            child: Text(
              name,
              style: TextStyle(color: Colors.indigo.contrastText),
            ),
          ),
        ),
        const Expanded(child: Placeholder()),
      ],
    ),
  );
}
```

It fills the width its parent allows. It throws `ArgumentError` for a
translucent color, `StateError` under a `SafeArea`, an `AppBar`, a `ListView`
or a modal sheet, where it can't reach the status bar, and `FlutterError` in a
`Row` without `Expanded`, where it has no width to fill. A `ListView` below it
in the `Column` still pads for the status bar; with a list, make the header the
first sliver of a `CustomScrollView`. For a gradient or an image, use
`StatusBarIcons` below.

`StatusBarIcons.light` and `.dark` set the status-bar icons on iOS and Android,
exactly as an `AppBar` derives them. `SystemUiOverlayStyle.light` and `.dark`
also paint the Android navigation bar black.

```dart
final blackAppBar = AppBar(
  backgroundColor: Colors.black,
  systemOverlayStyle: StatusBarIcons.light,
);

// A dark hero image at the top of a page without an AppBar.
Widget hero(ImageProvider image) {
  return AnnotatedRegion(
    value: StatusBarIcons.light,
    child: Image(image: image, height: 300, fit: .cover),
  );
}
```

A colored bottom bar needs no widget: put the color outside the `SafeArea`, so
it reaches under the home indicator.

```dart
Widget bottomBar(Widget actions) {
  return ColoredBox(
    color: Colors.indigo,
    child: SafeArea(top: false, child: actions),
  );
}
```

## `UnfocusOnTapOutside`

Unfocuses the active text field on outside touch taps without blocking
scrolling, dragging, or accessibility. Unlike wrapping a screen in a
`GestureDetector`, it overrides `EditableText`'s tap-outside intents: touch
waits for pointer up and cancels if the pointer moves past touch slop, is
cancelled, is held as a long press, or stops a flinging list, while mouse and
stylus keep Flutter's pointer-down behavior.

```dart
Widget app(Widget home) {
  return UnfocusOnTapOutside(child: MaterialApp(home: home));
}
```

Switching between text fields, tapping `InputDecoration` icons, selection
handles, or context menus keeps focus via `TextFieldTapRegion`. Wrap any
companion button that should keep the keyboard open (such as a chat send
button) in `TextFieldTapRegion`, or wrap a subtree in
`UnfocusOnTapOutside(enabled: false, ...)` to opt back out. For drag-to-dismiss
in scrollables, pair with `ScrollViewKeyboardDismissBehavior.onDrag` on your
`ScrollBehavior` or `ListView`.
