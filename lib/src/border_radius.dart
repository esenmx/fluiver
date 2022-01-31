part of dashx;

extension CircularBorderRadiusExtensions on BorderRadius {
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

  BorderRadius get removeLeft => setLeft(0);

  BorderRadius get removeTop => setTop(0);

  BorderRadius get removeRight => setRight(0);

  BorderRadius get removeBottom => setBottom(0);

  BorderRadius get removeTopLeft => setTopLeft(0);

  BorderRadius get removeTopRight => setTopRight(0);

  BorderRadius get removeBottomRight => setBottomRight(0);

  BorderRadius get removeBottomLeft => setBottomLeft(0);
}
