# fluiver

A comprehensive package that includes expressive extensions, common helpers, and essential widgets.

The expressiveness emulates IDE behaviors rather than merely minimizing code verbosity, distinguishing it from the typical approaches of many other packages.

## Extensions

### [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)

#### Screen Size

```dart
context.screenWidth => MediaQuery.of(context).size.width
context.screenHeight => MediaQuery.of(context).size.height
```

#### Brightness

```dart
context.isPlatformDark => MediaQuery.of(context).platformBrightness == Brightness.dark
context.isPlatformLight => MediaQuery.of(context).platformBrightness == Brightness.light
context.isThemeDark => Theme.of(context).brightness == Brightness.dark
context.isThemeLight => Theme.of(context).brightness == Brightness.light
```

#### Orientation

```dart
context.isOrientationPortrait => MediaQuery.of(context).orientation == Orientation.portrait
context.isOrientationLandscape => MediaQuery.of(context).orientation == Orientation.landscape
```

#### View Padding

```dart
context.topViewPadding => MediaQuery.of(context).viewPadding.top
context.bottomViewPadding => MediaQuery.of(context).viewPadding.bottom
context.bottomViewInset => MediaQuery.of(context).viewInsets.bottom
```

#### Directionality

```dart
context.isLTR => Directionality.of(context) == TextDirection.ltr
context.isRTL => Directionality.of(context) == TextDirection.rtl
```

### [ColorScheme](https://api.flutter.dev/flutter/material/ColorScheme-class.html)

```dart
// Formula
Color {$type}Color => Theme.of(context).colorScheme.{$type}Color!
```

```dart
// Examples
Color primaryColor => Theme.of(context).colorScheme.primaryColor
Color tertiaryColor => Theme.of(context).colorScheme.tertiaryColor
Color onErrorColor => Theme.of(context).colorScheme.onErrorColor
```

### [TextTheme](https://api.flutter.dev/flutter/material/TextTheme-class.html)

```dart
// Formula
TextStyle {$type}TextStyle => Theme.of(context).textTheme.{$type}!
```

```dart
// Examples
TextStyle headlineLargeTextStyle => Theme.of(context).textTheme.headlineLarge!
TextStyle bodyLargeTextStyle => Theme.of(context).textTheme.bodyLarge!
TextStyle labelMediumTextStyle => Theme.of(context).textTheme.labelMedium!
```

### [BorderRadius](https://api.flutter.dev/flutter/painting/BorderRadius-class.html)

#### add(double value)

```dart
// Formula
myBorderRadius + BorderRadius.add$type$(double value);
```

`addAll` `addLeft` `addTop` `addRight` `addBottom` `addTopLeft` `addTopRight` `addBottomRight` `addBottomLeft`

### [EdgeInsets](https://api.flutter.dev/flutter/painting/EdgeInsets-class.html)

#### Add(double value)

```dart
// Formula
myEdgeInsets + EdgeInsets.add$type$($type$: value);
```

`addAll` `addLeft` `addTop` `addRight` `addBottom`

#### Set(double value)

```dart
// Formula
myEdgeInsets.copyWith($type$: value);
```

`setLeft` `setTop` `setRight` `setBottom` `setHorizontal` `setVertical`

#### Only

```dart
// Formula
EdgeInsets.only($type$: value);
```

`setLeft` `setTop` `setRight` `setBottom` `setHorizontal` `setVertical`

### [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html)

#### [Color](https://api.flutter.dev/flutter/painting/TextStyle/color.html)

```dart
// Formula
TextStyle get withColor{$type} => textStyle.copyWith(color: {$type});
```

```dart
// Examples
TextStyle get withColorWhite38 => textStyle.copyWith(color: Colors.white38);
TextStyle get withColorWhite   => textStyle.copyWith(color: Colors.white);
TextStyle get withColorBlack70 => textStyle.copyWith(color: Colors.black70);
```

#### [ThemeColor](https://api.flutter.dev/flutter/painting/TextStyle/color.html)

```dart
// Formula
TextStyle get with{$type}Color => textStyle.copyWith(color: Theme.of(context).colorScheme.{$type});
```

```dart
// Example
TextStyle get withPrimaryColor(BuildContext context)   => textStyle.copyWith(color: Theme.of(context).colorScheme.primary);
TextStyle get withSecondaryColor(BuildContext context) => textStyle.copyWith(color: Theme.of(context).colorScheme.secondary);
TextStyle get withErrorColor(BuildContext context)     => textStyle.copyWith(color: Theme.of(context).colorScheme.error);
```

#### [FontWeight](https://api.flutter.dev/flutter/painting/TextStyle/fontWeight.html)

```dart
// Formula
TextStyle get withWeight{$type} => textStyle.copyWith(fontWeight: FontWeight.w${type});
```

```dart
// Example
TextStyle get withWeight100 => textStyle.copyWith(fontWeight: FontWeight.w100);
TextStyle get withWeight400 => textStyle.copyWith(fontWeight: FontWeight.w400);
TextStyle get withWeight700 => textStyle.copyWith(fontWeight: FontWeight.w700);
```

#### [TextDecoration](https://api.flutter.dev/flutter/painting/TextStyle/decoration.html)

```dart
// Formula
with{$type} => textStyle.copyWith(decoration: TextDecoration.{$type});
```

```dart
// Examples
withUnderline   => textStyle.copyWith(decoration: TextDecoration.underline);
withOverline    => textStyle.copyWith(decoration: TextDecoration.overline);
withLineThrough => textStyle.copyWith(decoration: TextDecoration.lineThrough);
```

#### [Size](https://api.flutter.dev/flutter/painting/TextStyle/fontSize.html)

```dart
withSize(double size) => textStyle.copyWith(fontSize: size);
```

### [DateTime](https://api.dart.dev/stable/dart-core/DateTime-class.html)

```dart
TimeOfDay toTime(); /// Creates [TimeOfDay] from [DateTime]
DateTime truncateTime(); /// Sets '0' everything other than [year, month, day].
DateTime withTimeOfDay(TimeOfDay time); /// copies [hour, minute] from [time] and sets '0' everything smaller

DateTime addYears(int years);
DateTime addMonths(int months);
DateTime addWeeks(int weeks);
DateTime addDays(int days);
DateTime addHours(int hours);
DateTime addMinutes(int minutes);
DateTime addSeconds(int seconds);

bool get isToday;
bool get isTomorrow;
bool get isYesterday;

bool isWithinFromNow(Duration duration); /// Checks is difference between [DateTime.now()] and [DateTime] is smaller than [duration]
```

### [Map](https://api.dart.dev/stable/dart-core/Map-class.html)

```dart
bool any(bool Function(K key, V value) test); // Similar to [Iterable.any]
bool every(bool Function(K key, V value) test); // Similar to [Iterable.every]

MapEntry<K, V>? firstWhereOrNull(bool Function(K key, V value) test); // Similar to [Iterable.firstWhereOrNull]
Map<K, V> where(bool Function(K key, V value) test); // Similar to [Iterable.where]
Map<T, V> whereKeyType<T>(); // Similar to [Iterable.whereType]
Map<K, T> whereValueType<T>(); // Similar to [Iterable.whereType]

MapEntry<K, V>? entryOf(K k); // Similar to `[]` operator but returns [MapEntry]
```

### [Set](https://api.dart.dev/stable/dart-core/Set-class.html)

```dart
Set<E> subset(int start, [int? end]); // Creates a new sub [Set]
```

### [String](https://api.dart.dev/stable/dart-core/String-class.html)

```dart
String capitalize();
String capitalizeAll({String separator = ' ', String? joiner});
/// Retrieves first letters of each word separated by [separator] and merge them with [joiner]
String initials({String separator = ' ', String joiner = ''});
```

### [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html)

```dart
[1, 2, 3].to2D(2) // [[1, 2], [3]]
[[1, 2], [3]].from2D // [1, 2, 3]
[Foo(), Foo(), Foo()].widgetJoin(() => Divider()) // [Foo(), Divider(), Foo(), Divider(), Foo()]
```

### Iterable\<int>

```dart
int sum(); // sum of every element
double average(); // average value of iterable
Uint8List toBytes(); // Create a byte array from this
```

### Iterable\<double>

```dart
double sum(); // sum of every element
double average(); // average value of iterable
```

### IterableNum\<T extends num>

```dart
T get lowest; // lower value in iterable
T get highest; /// highest value in iterable
```

## Widgets

### FlexGrid

A non-scrollable replacement for `GridView` where nested [ScrollView](https://api.flutter.dev/flutter/widgets/ScrollView-class.html). is a subject.

### PaddedColumn

A [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) with [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html).

### PaddedRow

A [Row](https://api.flutter.dev/flutter/widgets/Row-class.html) with [Padding](https://api.flutter.dev/flutter/widgets/Padding-class.html).

### ScrollViewColumn

A [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) inside [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html). Easy way to keep children alive.

## Principles

Only commonly needed widgets and helpers are implemented.

For extensions, few comparison will explain the motivation behind.

```dart
context.mediaQuery // BAD: therefore, it's not implemented
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

### Package Name

Inspired by [google/quiver-dart](https://github.com/google/quiver-dart)

`flutter` + `quiver` = `fluiver`
