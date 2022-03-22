part of dashx;

class Space extends StatelessWidget {
  ///
  /// Horizontal
  ///
  const Space.h4({Key? key})
      : width = 4,
        height = 0,
        super(key: key);

  const Space.h8({Key? key})
      : width = 8,
        height = 0,
        super(key: key);

  const Space.h16({Key? key})
      : width = 16,
        height = 0,
        super(key: key);

  const Space.h24({Key? key})
      : width = 24,
        height = 0,
        super(key: key);

  const Space.h32({Key? key})
      : width = 32,
        height = 0,
        super(key: key);

  const Space.h48({Key? key})
      : width = 48,
        height = 0,
        super(key: key);

  ///
  /// Vertical
  ///
  const Space.v4({Key? key})
      : width = 0,
        height = 4,
        super(key: key);

  const Space.v8({Key? key})
      : width = 0,
        height = 8,
        super(key: key);

  const Space.v16({Key? key})
      : width = 0,
        height = 16,
        super(key: key);

  const Space.v24({Key? key})
      : width = 0,
        height = 24,
        super(key: key);

  const Space.v32({Key? key})
      : width = 0,
        height = 32,
        super(key: key);

  const Space.v48({Key? key})
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
