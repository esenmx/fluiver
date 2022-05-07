## fluiver

Name from `Flutter` + `Quiver` = `Fluiver`.

Dependency free; extensions, widgets and helpers package. Focused on productivity with an eye
to `IDE` behaviours rather than reducing the amount of written code roughly.

### Widgets
`TODO`

### X

#### BuildContext

```dart
// MediaQuery
context.screenWidth // MediaQuery.of(context).size.width
context.screenHeight // MediaQuery.of(context).size.height

context.isPlatformDark // MediaQuery.of(context).platformBrightness == Brightness.dark
context.isPlatformLight // MediaQuery.of(context).platformBrightness == Brightness.light

context.isOrientationPortrait // MediaQuery.of(context).orientation == Orientation.portrait
context.isOrientationLandscape // MediaQuery.of(context).orientation == Orientation.landscape

context.topPadding // MediaQuery.of(context).padding.top
context.bottomPadding // MediaQuery.of(context).padding.bottom
context.bottomInset // MediaQuery.of(context).viewInsets.bottom

// Directionality
context.isLTR // Directionality.of(context) == TextDirection.ltr
context.isRTL // Directionality.of(context) == TextDirection.rtl

// ColorScheme
context.primaryColor // Theme.of(context).colorScheme.primary
context.primaryContainerColor // Theme.of(context).colorScheme.primaryContainer
context.secondaryColor // Theme.of(context).colorScheme.secondary
context.surfaceColor // Theme.of(context).colorScheme.surface
context.backgroundColor // Theme.of(context).colorScheme.background
context.errorColor // Theme.of(context).colorScheme.error

// TextTheme
context.headline1TextStyle // Theme.of(context).textTheme.headline1!
context.headline2TextStyle // Theme.of(context).textTheme.headline2!
context.headline3TextStyle // Theme.of(context).textTheme.headline3!
context.headline4TextStyle // Theme.of(context).textTheme.headline4!
context.headline5TextStyle // Theme.of(context).textTheme.headline5!
context.headline6TextStyle // Theme.of(context).textTheme.headline6!
context.subtitle1TextStyle // Theme.of(context).textTheme.subtitle1!
context.subtitle2TextStyle // Theme.of(context).textTheme.subtitle2!
context.body1TextStyle // Theme.of(context).textTheme.bodyText1!
context.body2TextStyle // Theme.of(context).textTheme.bodyText2!
context.captionTextStyle // Theme.of(context).textTheme.caption!
context.buttonTextStyle // Theme.of(context).textTheme.button!
context.overlineTextStyle // Theme.of(context).textTheme.overline!
```


#### Duration
``TODO``

#### BorderRadius
``TODO``

#### EdgeInsets
``TODO``

#### TextStyle
``TODO``

#### DateTime
``TODO``

#### Map
``TODO``

#### Set
``TODO``

#### String
``TODO``

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
context.bottomInset // GOOD: two dots less and decent readability
```

```dart
// Theme.of(context).textTheme.caption!
context.caption // BAD: less expressive
context.captionTextStyle // GOOD: more expressive, better auto code-completion
```

#### Inspirations

* [leisim/dartx](https://github.com/leisim/dartx)
* [gskinner/flextras](https://github.com/gskinnerTeam/flutter-flextras)