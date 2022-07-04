part of fluiver;

class GoogleAvatar extends StatelessWidget {
  GoogleAvatar({
    Key? key,
    required this.name,
    this.size = kMinInteractiveDimension,
    this.colors = Colors.primaries,
    int? index,
  })  : assert(name.isNotEmpty),
        assert(colors.isNotEmpty),
        _color = colors[index ?? name.hashCode % Colors.primaries.length],
        super(key: key);

  final String name;
  final double size;
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
        name.initials().safeSubstring(0, 2).toUpperCase(),
        maxLines: 1,
        style: TextStyle(
          fontSize: size * .6,
          color: _isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
