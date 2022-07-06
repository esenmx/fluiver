part of fluiver;

extension AddCircularBorderRadiusX on BorderRadius {
  BorderRadius addAll(double radius) {
    return this + BorderRadius.circular(radius);
  }

  BorderRadius addLeft(double radius) {
    return this + BorderRadius.horizontal(left: Radius.circular(radius));
  }

  BorderRadius addTop(double radius) {
    return this + BorderRadius.vertical(top: Radius.circular(radius));
  }

  BorderRadius addRight(double radius) {
    return this + BorderRadius.horizontal(right: Radius.circular(radius));
  }

  BorderRadius addBottom(double radius) {
    return this + BorderRadius.vertical(bottom: Radius.circular(radius));
  }

  BorderRadius addTopLeft(double radius) {
    return this + BorderRadius.only(topLeft: Radius.circular(radius));
  }

  BorderRadius addTopRight(double radius) {
    return this + BorderRadius.only(topRight: Radius.circular(radius));
  }

  BorderRadius addBottomRight(double radius) {
    return this + BorderRadius.only(bottomRight: Radius.circular(radius));
  }

  BorderRadius addBottomLeft(double radius) {
    return this + BorderRadius.only(bottomLeft: Radius.circular(radius));
  }
}

extension SetCircularBorderRadiusX on BorderRadius {
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
    return copyWith(topLeft: Radius.circular(radius));
  }

  BorderRadius setTopRight(double radius) {
    return copyWith(topRight: Radius.circular(radius));
  }

  BorderRadius setBottomRight(double radius) {
    return copyWith(bottomRight: Radius.circular(radius));
  }

  BorderRadius setBottomLeft(double radius) {
    return copyWith(bottomLeft: Radius.circular(radius));
  }
}

extension EliminateCircularBorderRadiusX on BorderRadius {
  BorderRadius get onlyTopLeft {
    return BorderRadius.only(topLeft: topLeft);
  }

  BorderRadius get onlyTopRight {
    return BorderRadius.only(topRight: topRight);
  }

  BorderRadius get onlyBottomRight {
    return BorderRadius.only(bottomRight: bottomRight);
  }

  BorderRadius get onlyBottomLeft {
    return BorderRadius.only(bottomLeft: bottomLeft);
  }

  BorderRadius get onlyLeft {
    return BorderRadius.only(topLeft: topLeft, bottomLeft: bottomLeft);
  }

  BorderRadius get onlyTop {
    return BorderRadius.only(topLeft: topLeft, topRight: topRight);
  }

  BorderRadius get onlyRight {
    return BorderRadius.only(topRight: topRight, bottomRight: bottomRight);
  }

  BorderRadius get onlyBottom {
    return BorderRadius.only(bottomRight: bottomRight, bottomLeft: bottomLeft);
  }
}
