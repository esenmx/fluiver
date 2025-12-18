part of '../../fluiver.dart';

/// {@macro extensionFor}
/// [Axis] enum operations.
extension EnumAxis on Axis {
  Axis get reverse => isVertical ? .horizontal : .vertical;

  bool get isVertical => this == .vertical;
  bool get isHorizontal => this == .horizontal;
}

/// {@macro extensionFor}
/// [TextDirection] enum operations.
extension EnumTextDirection on TextDirection {
  TextDirection get reverse => isLtr ? .rtl : .ltr;

  bool get isLtr => this == .ltr;
  bool get isRtl => this == .rtl;
}

/// {@macro extensionFor}
/// [Brightness] enum operations.
extension EnumBrightness on Brightness {
  Brightness get reverse => isLight ? .dark : .light;

  bool get isLight => this == .light;
  bool get isDark => this == .dark;
}

/// {@macro extensionFor}
/// [Orientation] enum operations.
extension EnumOrientation on Orientation {
  Orientation get reverse => isPortrait ? .landscape : .portrait;

  bool get isPortrait => this == .portrait;
  bool get isLandscape => this == .landscape;
}

/// {@macro extensionFor}
/// [AppLifecycleState] enum checks.
extension EnumAppLifecycleState on AppLifecycleState {
  bool get isResumed => this == .resumed;
  bool get isInactive => this == .inactive;
  bool get isPaused => this == .paused;
  bool get isDetached => this == .detached;
}
