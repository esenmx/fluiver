part of '../../fluiver.dart';

/// {@macro extensionFor}
/// [Axis] enum operations.
extension EnumAxis on Axis {
  Axis get reverse => this == .vertical ? .horizontal : .vertical;
}

/// {@macro extensionFor}
/// [TextDirection] enum operations.
extension EnumTextDirection on TextDirection {
  TextDirection get reverse => this == .ltr ? .rtl : .ltr;
}

/// {@macro extensionFor}
/// [Brightness] enum operations.
extension EnumBrightness on Brightness {
  Brightness get reverse => this == .light ? .dark : .light;
}

/// {@macro extensionFor}
/// [Orientation] enum operations.
extension EnumOrientation on Orientation {
  Orientation get reverse => this == .portrait ? .landscape : .portrait;
}
