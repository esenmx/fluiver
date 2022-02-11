## dashx

Inspired from [leisim/dartx](https://github.com/leisim/dartx)

An un-opinionated, dependency free, expressive extensions package. Focused on productivity with an eye to IDE behaviours
rather than reducing the amount of written code roughly.

To get and idea, let's have a look at this:

```dart
context.mediaQuery // Equivalent of MediaQuery.of(context)
```

Does not make any sense, so not implemented. Because:

* quantity of written dots is not reduced
* bloats `BuildContext` extensions
* code readability relatively reduced, because `MediaQuery.of(context)` is more characteristic, hence readable

Let's take another example, the caption `TextStyle` extension in `dashx` is:

```dart
context.captionTextStyle // Equivalent of Theme.of(context).textTheme.caption!
```

It's not:

```dart
context.caption
```

Because:

* improved readability and more characteristic without extra dots
* better catch on intelli-sense, try and see ;)

### Iterable

```dart
[1, 2, 3].convertTo2D(2) // [[1, 2], [3]]
[[1, 2], [3]].expandFrom2D // [1, 2, 3]
[Container(), Container()].widgetJoin(Divider()) // [Container(), Divider(), Container()]
```

### BuildContext

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

// TextTheme
contetx.headline1TextStyle // Theme.of(context).textTheme.headline1!
contetx.headline2TextStyle // Theme.of(context).textTheme.headline2!
contetx.headline3TextStyle // Theme.of(context).textTheme.headline3!
contetx.headline4TextStyle // Theme.of(context).textTheme.headline4!
contetx.headline5TextStyle // Theme.of(context).textTheme.headline5!
contetx.headline6TextStyle // Theme.of(context).textTheme.headline6!
contetx.subtitle1TextStyle // Theme.of(context).textTheme.subtitle1!
contetx.subtitle2TextStyle // Theme.of(context).textTheme.subtitle2!
contetx.bodyText1TextStyle // Theme.of(context).textTheme.bodyText1!
contetx.bodyText2TextStyle // Theme.of(context).textTheme.bodyText2!
contetx.captionTextStyle // Theme.of(context).textTheme.caption!
contetx.buttonTextStyle // Theme.of(context).textTheme.button!
contetx.overlineTextStyle // Theme.of(context).textTheme.overline!

// Directionality
context.isLTR // Directionality.of(context) == TextDirection.ltr
context.isRTL // Directionality.of(context) == TextDirection.rtl

// ColorScheme
context.primaryColor
context.primaryColorDark
context.primaryColorLight
context.secondaryColor
context.surfaceColor
context.backgroundColor
context.errorColor

// Localization
context.localeOf
context.languageCode
context.countryCode
```
