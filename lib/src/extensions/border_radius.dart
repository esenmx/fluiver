part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Adding radius values to [BorderRadius].
extension BorderRadiusAdd on BorderRadius {
  BorderRadius addAll(double radius) {
    return this + .circular(radius);
  }

  BorderRadius addLeft(double radius) {
    return this + .horizontal(left: .circular(radius));
  }

  BorderRadius addTop(double radius) {
    return this + .vertical(top: .circular(radius));
  }

  BorderRadius addRight(double radius) {
    return this + .horizontal(right: .circular(radius));
  }

  BorderRadius addBottom(double radius) {
    return this + .vertical(bottom: .circular(radius));
  }

  BorderRadius addTopLeft(double radius) {
    return this + .only(topLeft: .circular(radius));
  }

  BorderRadius addTopRight(double radius) {
    return this + .only(topRight: .circular(radius));
  }

  BorderRadius addBottomRight(double radius) {
    return this + .only(bottomRight: .circular(radius));
  }

  BorderRadius addBottomLeft(double radius) {
    return this + .only(bottomLeft: .circular(radius));
  }
}

/// {@macro extensionFor}
/// Setting radius values on [BorderRadius].
extension BorderRadiusSet on BorderRadius {
  BorderRadius setLeft(double radius) {
    return setTopLeft(radius).setBottomLeft(radius);
  }

  BorderRadius setTop(double radius) {
    return setTopLeft(radius).setTopRight(radius);
  }

  BorderRadius setRight(double radius) {
    return setTopRight(radius).setBottomRight(radius);
  }

  BorderRadius setBottom(double radius) {
    return setBottomRight(radius).setBottomLeft(radius);
  }

  BorderRadius setTopLeft(double radius) {
    return copyWith(topLeft: .circular(radius));
  }

  BorderRadius setTopRight(double radius) {
    return copyWith(topRight: .circular(radius));
  }

  BorderRadius setBottomRight(double radius) {
    return copyWith(bottomRight: .circular(radius));
  }

  BorderRadius setBottomLeft(double radius) {
    return copyWith(bottomLeft: .circular(radius));
  }
}

/// {@macro extensionFor}
/// Extracting specific corners from [BorderRadius].
extension BorderRadiusOnly on BorderRadius {
  BorderRadius get onlyTopLeft {
    return .only(topLeft: topLeft);
  }

  BorderRadius get onlyTopRight {
    return .only(topRight: topRight);
  }

  BorderRadius get onlyBottomRight {
    return .only(bottomRight: bottomRight);
  }

  BorderRadius get onlyBottomLeft {
    return .only(bottomLeft: bottomLeft);
  }

  BorderRadius get onlyLeft {
    return .only(topLeft: topLeft, bottomLeft: bottomLeft);
  }

  BorderRadius get onlyTop {
    return .only(topLeft: topLeft, topRight: topRight);
  }

  BorderRadius get onlyRight {
    return .only(topRight: topRight, bottomRight: bottomRight);
  }

  BorderRadius get onlyBottom {
    return .only(bottomRight: bottomRight, bottomLeft: bottomLeft);
  }
}
