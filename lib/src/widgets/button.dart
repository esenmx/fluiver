part of fluiver;

/// Useful with Material style [TextField/TextFormField]. Provides splash on top
/// of the field with default respective size.
class FormSuffixButton extends StatelessWidget {
  const FormSuffixButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.radius = 24.0,
    this.tooltip,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;
  final double radius;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      child: IconButton(
        icon: icon,
        splashRadius: radius,
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
