import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color color;
  final double spacing;
  final TextStyle? textStyle;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.title,
    this.color = Colors.black,
    this.spacing = 10.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: spacing),
        Text(
          title,
        ),
      ],
    );
  }
}
