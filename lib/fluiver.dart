library;

/// {@template safeOperation}
/// Safe operation that doesn't throw errors.
/// {@endtemplate}
///
/// {@template similarToButNull}
/// Similar to the original method, but returns null instead of throwing
/// [StateError] when no element is found.
/// {@endtemplate}
///
/// {@template extensionFor}
/// Extension providing convenient access to operations on the target type.
/// {@endtemplate}
///
/// {@template returns_datetime}
/// Returns a new [DateTime] with the modification.
/// {@endtemplate}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

part 'src/extensions/bool.dart';
part 'src/extensions/border_radius.dart';
part 'src/extensions/build_context.dart';
part 'src/extensions/date_time.dart';
part 'src/extensions/edge_insets.dart';
part 'src/extensions/enum.dart';
part 'src/extensions/enums.dart';
part 'src/extensions/iterable.dart';
part 'src/extensions/key.dart';
part 'src/extensions/map.dart';
part 'src/extensions/object.dart';
part 'src/extensions/stream.dart';
part 'src/extensions/string.dart';
part 'src/extensions/text_style.dart';
part 'src/extensions/time_of_day.dart';
part 'src/helpers/functions.dart';
part 'src/helpers/observer.dart';
part 'src/helpers/reactive.dart';
part 'src/widgets/flex_grid.dart';
part 'src/widgets/padded_flex.dart';
part 'src/widgets/ticker_builder.dart';
