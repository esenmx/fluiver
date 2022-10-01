part of fluiver;

extension AxisX on Axis {
  Axis get reverse {
    return this == Axis.vertical ? Axis.horizontal : Axis.vertical;
  }

  bool get isVertical => this == Axis.vertical;

  bool get isHorizontal => this == Axis.horizontal;
}

extension TextDirectionX on TextDirection {
  TextDirection get reverse {
    return this == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr;
  }

  bool get isLtr => this == TextDirection.ltr;

  bool get isRtl => this == TextDirection.rtl;
}

extension BrightnessX on Brightness {
  Brightness get reverse {
    return this == Brightness.light ? Brightness.dark : Brightness.light;
  }

  bool get isLight => this == Brightness.light;

  bool get isDark => this == Brightness.dark;
}

extension OrientationX on Orientation {
  Orientation get reverse {
    return this == Orientation.portrait
        ? Orientation.landscape
        : Orientation.portrait;
  }

  bool get isPortrait => this == Orientation.portrait;

  bool get isLandscape => this == Orientation.landscape;
}
