part of dashx;

extension AddCircularBorderRadiusExtensions on BorderRadius {
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

extension SetCircularBorderRadiusExtensions on BorderRadius {
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

extension RemoveCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius get removeLeft => setLeft(0);

  BorderRadius get removeTop => setTop(0);

  BorderRadius get removeRight => setRight(0);

  BorderRadius get removeBottom => setBottom(0);

  BorderRadius get removeTopLeft => setTopLeft(0);

  BorderRadius get removeTopRight => setTopRight(0);

  BorderRadius get removeBottomRight => setBottomRight(0);

  BorderRadius get removeBottomLeft => setBottomLeft(0);
}

extension EliminateCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius get onlyTopLeft {
    return copyWith(topLeft: topLeft);
  }

  BorderRadius get onlyTopRight {
    return copyWith(topRight: topRight);
  }

  BorderRadius get onlyBottomRight {
    return copyWith(bottomRight: bottomRight);
  }

  BorderRadius get onlyBottomLeft {
    return copyWith(bottomLeft: bottomLeft);
  }

  BorderRadius get onlyLeft {
    return copyWith(topLeft: topLeft, bottomLeft: bottomLeft);
  }

  BorderRadius get onlyTop {
    return copyWith(topLeft: topLeft, topRight: topRight);
  }

  BorderRadius get onlyRight {
    return copyWith(topRight: topRight, bottomRight: bottomRight);
  }

  BorderRadius get onlyBottom {
    return copyWith(bottomRight: bottomRight, bottomLeft: bottomLeft);
  }
}
