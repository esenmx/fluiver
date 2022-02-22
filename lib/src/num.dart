part of dashx;

extension NumExtensions on num {
  num get square => this * this;

  num get cube => this * this * this;

  num get sqrt => math.sqrt(this);

  num get exp => math.exp(this);

  num pow(num exp) => math.pow(this, exp);

  num get log => math.log(this);
}

double numLerp<T extends num>(T a, T b, double t) => a + (b - a) * t;
