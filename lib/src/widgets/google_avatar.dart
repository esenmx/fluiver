part of fluiver;

final _rand = Random();

class GoogleAvatar extends StatelessWidget {
  GoogleAvatar({
    Key? key,
    required this.name,
    this.size = kMinInteractiveDimension,
    this.index,
    this.colors = Colors.primaries,
  })  : assert(name.isNotEmpty),
        assert(colors.isNotEmpty),
        _color = colors.elementAt(index != null
            ? index % Colors.primaries.length
            : _rand.nextInt(colors.length)),
        super(key: key);

  /// Raw full name, no manipulation required
  final String name;

  /// Circle size
  final double size;

  /// To prevent duplicate colors or create a gradual color change in sequential
  /// widgets, you can provide the index
  final int? index;

  /// Color palette for generating
  final List<Color> colors;

  final Color _color;
  late final bool _isDark = _color.computeLuminance() < .5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
      alignment: Alignment.center,
      child: Text(
        name.avatarLetters(),
        maxLines: 1,
        style: TextStyle(
          fontSize: size * .5,
          color: _isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
