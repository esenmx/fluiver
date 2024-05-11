part of '../../fluiver.dart';

extension EnumAxis on Axis {
  Axis get reverse => isVertical ? Axis.horizontal : Axis.vertical;

  bool get isVertical => this == Axis.vertical;
  bool get isHorizontal => this == Axis.horizontal;
}

extension EnumTextDirection on TextDirection {
  TextDirection get reverse => isLtr ? TextDirection.rtl : TextDirection.ltr;

  bool get isLtr => this == TextDirection.ltr;
  bool get isRtl => this == TextDirection.rtl;
}

extension EnumBrightness on Brightness {
  Brightness get reverse => isLight ? Brightness.dark : Brightness.light;

  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;
}

extension EnumOrientation on Orientation {
  Orientation get reverse =>
      isPortrait ? Orientation.landscape : Orientation.portrait;

  bool get isPortrait => this == Orientation.portrait;
  bool get isLandscape => this == Orientation.landscape;
}

extension EnumAppLifecycleState on AppLifecycleState {
  bool get isResumed => this == AppLifecycleState.resumed;
  bool get isInactive => this == AppLifecycleState.inactive;
  bool get isPaused => this == AppLifecycleState.paused;
  bool get isDetached => this == AppLifecycleState.detached;
}
