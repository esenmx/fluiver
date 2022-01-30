part of dashx;

extension CircularBorderRadiusExtensions on BorderRadius {
  BorderRadius addAll(double radius) => this + BorderRadius.circular(radius);

  BorderRadius addTopLeft(double radius) =>
      this + BorderRadius.only(topLeft: Radius.circular(radius));

  BorderRadius addTopRight(double radius) =>
      this + BorderRadius.only(topRight: Radius.circular(radius));

  BorderRadius addBottomRight(double radius) =>
      this + BorderRadius.only(bottomRight: Radius.circular(radius));

  BorderRadius addBottomLeft(double radius) =>
      this + BorderRadius.only(bottomLeft: Radius.circular(radius));

  BorderRadius get removeTopLeft => copyWith(topLeft: const Radius.circular(0));

  BorderRadius get removeTopRight =>
      copyWith(topRight: const Radius.circular(0));

  BorderRadius get removeBottomRight =>
      copyWith(bottomRight: const Radius.circular(0));

  BorderRadius get removeBottomLeft =>
      copyWith(bottomLeft: const Radius.circular(0));
}
