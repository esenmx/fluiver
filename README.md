# fluiver

Dependency free; extensions, widgets and helpers package. Focused on productivity with an eye
to `IDE` behaviors rather than reducing the amount of written code roughly(which most packages do).

## [Extensions](https://dart.dev/guides/language/extension-methods)

### [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)

```dart
double screenWidth => MediaQuery.of(context).size.width
double screenHeight => MediaQuery.of(context).size.height

bool isPlatformDark => MediaQuery.of(context).platformBrightness == Brightness.dark
bool isPlatformLight => MediaQuery.of(context).platformBrightness == Brightness.light

bool isThemeDark => Theme.of(context).brightness == Brightness.dark
bool isThemeLight => Theme.of(context).brightness == Brightness.light

bool isOrientationPortrait => MediaQuery.of(context).orientation == Orientation.portrait
bool isOrientationLandscape => MediaQuery.of(context).orientation == Orientation.landscape

double topViewPadding => MediaQuery.of(context).viewPadding.top
double bottomViewPadding => MediaQuery.of(context).viewPadding.bottom
double bottomViewInset => MediaQuery.of(context).viewInsets.bottom

bool isLTR => Directionality.of(context) == TextDirection.ltr
bool isRTL => Directionality.of(context) == TextDirection.rtl
```

#### [ColorScheme](https://api.flutter.dev/flutter/material/ColorScheme-class.html)

Format:

```dart
Color {$type}Color => Theme.of(context).colorScheme.{$type}Color!
```

Examples:

```dart
Color primaryColor => Theme.of(context).colorScheme.primaryColor
Color tertiaryColor => Theme.of(context).colorScheme.tertiaryColor
Color onErrorColor => Theme.of(context).colorScheme.onErrorColor
```

#### [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html)

Format:

```dart
TextStyle {$type}TextStyle => Theme.of(context).textTheme.{$type}!
```

Examples:

```dart
TextStyle headlineLargeTextStyle => Theme.of(context).textTheme.headlineLarge!
TextStyle bodyLargeTextStyle => Theme.of(context).textTheme.bodyLarge!
TextStyle labelMediumTextStyle => Theme.of(context).textTheme.labelMedium!
```

#### BorderRadius

``TODO``

#### EdgeInsets

``TODO``

#### TextStyle

``TODO``

#### DateTime

``TODO``

#### Map

```dart
bool any(bool Function(K key, V value) test)
```

#### Set

``TODO``

#### [String](https://api.dart.dev/stable/2.19.0/dart-core/String-class.html)

```dart
String capitalize();
String capitalizeAll({String separator = ' ', String? joiner});
/// Retrieves first letters of each word separated by [separator] and merge them with [joiner]
String initials({String separator = ' ', String joiner = ''});
```

#### Iterable

```dart
[1, 2, 3].to2D(2) // [[1, 2], [3]]
[[1, 2], [3]].from2D // [1, 2, 3]
[Foo(), Foo()].widgetJoin(() => Divider()) // [Foo(), Divider(), Foo()]
```

#### IterableInt

``TODO``

#### IterableDouble

``TODO``

### Principles

Only commonly needed widgets and helpers implemented.

For extensions, few comparison will explain the motivation behind.

```dart
context.mediaQuery // BAD: hence, not implemented
MediaQuery.of(context) // GOOD: better fast read, more characteristic
```

```dart
// MediaQuery.of(context).viewInsets.bottom
context.mediaQuery.viewInsets.bottom // BAD: number of dots is same
context.bottomViewInset // GOOD: two dots less and decent readability
```

```dart
// Theme.of(context).textTheme.bodyMediumTextStyle!
context.bodyMedium // BAD: less expressive
context.bodyMediumTextStyle // GOOD: more expressive, better auto code-completion
```

## [Widgets](https://api.flutter.dev/flutter/widgets/Widget-class.html)

### FlexGrid

A non-scrollable `GridView`. Big performance gains when used inside [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html).

### PaddedColumn

A [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) with [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html).

### PaddedRow

A [Row](https://api.flutter.dev/flutter/widgets/Row-class.html) with [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html).

### ScrollViewColumn

A [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) inside [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html). Easy way to keep alive the children.


#### Name
Name from `Flutter` + `Quiver` = `Fluiver`.
Inspired from [google/quiver-dart](https://github.com/google/quiver-dart)