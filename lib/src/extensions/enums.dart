part of fluiver;

extension AxisX on Axis {
  Axis get reverse => isVertical ? Axis.horizontal : Axis.vertical;

  bool get isVertical => this == Axis.vertical;

  bool get isHorizontal => this == Axis.horizontal;
}

extension TextDirectionX on TextDirection {
  TextDirection get reverse => isLtr ? TextDirection.rtl : TextDirection.ltr;

  bool get isLtr => this == TextDirection.ltr;

  bool get isRtl => this == TextDirection.rtl;
}

extension BrightnessX on Brightness {
  Brightness get reverse => isLight ? Brightness.dark : Brightness.light;

  bool get isLight => this == Brightness.light;

  bool get isDark => this == Brightness.dark;
}

extension OrientationX on Orientation {
  Orientation get reverse {
    return isPortrait ? Orientation.landscape : Orientation.portrait;
  }

  bool get isPortrait => this == Orientation.portrait;

  bool get isLandscape => this == Orientation.landscape;
}
