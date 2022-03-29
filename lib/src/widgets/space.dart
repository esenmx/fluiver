part of fluiver;

// coverage:ignore-file

class Space extends StatelessWidget {
  ///
  /// Width
  ///
  const Space.w4({Key? key})
      : width = 4,
        height = 0,
        super(key: key);

  const Space.w8({Key? key})
      : width = 8,
        height = 0,
        super(key: key);

  const Space.w12({Key? key})
      : width = 12,
        height = 0,
        super(key: key);

  const Space.w16({Key? key})
      : width = 16,
        height = 0,
        super(key: key);

  const Space.w24({Key? key})
      : width = 24,
        height = 0,
        super(key: key);

  const Space.w32({Key? key})
      : width = 32,
        height = 0,
        super(key: key);

  const Space.w48({Key? key})
      : width = 48,
        height = 0,
        super(key: key);

  ///
  /// Height
  ///
  const Space.h4({Key? key})
      : width = 0,
        height = 4,
        super(key: key);

  const Space.h8({Key? key})
      : width = 0,
        height = 8,
        super(key: key);

  const Space.h12({Key? key})
      : width = 0,
        height = 12,
        super(key: key);

  const Space.h16({Key? key})
      : width = 0,
        height = 16,
        super(key: key);

  const Space.h24({Key? key})
      : width = 0,
        height = 24,
        super(key: key);

  const Space.h32({Key? key})
      : width = 0,
        height = 32,
        super(key: key);

  const Space.h48({Key? key})
      : width = 0,
        height = 48,
        super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
