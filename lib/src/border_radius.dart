part of dashx;

extension AddCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius addAll(double radius) => this + BorderRadius.circular(radius);

  BorderRadius addLeft(double radius) =>
      this + BorderRadius.horizontal(left: Radius.circular(radius));

  BorderRadius addTop(double radius) =>
      this + BorderRadius.vertical(top: Radius.circular(radius));

  BorderRadius addRight(double radius) =>
      this + BorderRadius.horizontal(right: Radius.circular(radius));

  BorderRadius addBottom(double radius) =>
      this + BorderRadius.vertical(bottom: Radius.circular(radius));

  BorderRadius addTopLeft(double radius) =>
      this + BorderRadius.only(topLeft: Radius.circular(radius));

  BorderRadius addTopRight(double radius) =>
      this + BorderRadius.only(topRight: Radius.circular(radius));

  BorderRadius addBottomRight(double radius) =>
      this + BorderRadius.only(bottomRight: Radius.circular(radius));

  BorderRadius addBottomLeft(double radius) =>
      this + BorderRadius.only(bottomLeft: Radius.circular(radius));
}

extension SetCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius setLeft(double radius) =>
      setTopLeft(radius).setBottomLeft(radius);

  BorderRadius setTop(double radius) => setTopLeft(radius).setTopRight(radius);

  BorderRadius setRight(double radius) =>
      setTopRight(radius).setBottomRight(radius);

  BorderRadius setBottom(double radius) =>
      setBottomRight(radius).setBottomLeft(radius);

  BorderRadius setTopLeft(double radius) =>
      copyWith(topLeft: Radius.circular(radius));

  BorderRadius setTopRight(double radius) =>
      copyWith(topRight: Radius.circular(radius));

  BorderRadius setBottomRight(double radius) =>
      copyWith(bottomRight: Radius.circular(radius));

  BorderRadius setBottomLeft(double radius) =>
      copyWith(bottomLeft: Radius.circular(radius));
}

extension RemoveCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius get removeLeft =>
      copyWith(topLeft: Radius.zero, bottomLeft: Radius.zero);

  BorderRadius get removeTop =>
      copyWith(topLeft: Radius.zero, topRight: Radius.zero);

  BorderRadius get removeRight =>
      copyWith(topRight: Radius.zero, bottomRight: Radius.zero);

  BorderRadius get removeBottom =>
      copyWith(bottomRight: Radius.zero, bottomLeft: Radius.zero);

  BorderRadius get removeTopLeft => copyWith(topLeft: Radius.zero);

  BorderRadius get removeTopRight => copyWith(topRight: Radius.zero);

  BorderRadius get removeBottomRight => copyWith(bottomRight: Radius.zero);

  BorderRadius get removeBottomLeft => copyWith(bottomLeft: Radius.zero);
}

extension EliminateCircularBorderRadiusExtensions on BorderRadius {
  BorderRadius get onlyTopLeft => BorderRadius.only(topLeft: topLeft);

  BorderRadius get onlyTopRight => BorderRadius.only(topRight: topRight);

  BorderRadius get onlyBottomRight =>
      BorderRadius.only(bottomRight: bottomRight);

  BorderRadius get onlyBottomLeft => BorderRadius.only(bottomLeft: bottomLeft);

  BorderRadius get onlyLeft =>
      BorderRadius.only(topLeft: topLeft, bottomLeft: bottomLeft);

  BorderRadius get onlyTop =>
      BorderRadius.only(topLeft: topLeft, topRight: topRight);

  BorderRadius get onlyRight =>
      BorderRadius.only(topRight: topRight, bottomRight: bottomRight);

  BorderRadius get onlyBottom =>
      BorderRadius.only(bottomRight: bottomRight, bottomLeft: bottomLeft);
}
