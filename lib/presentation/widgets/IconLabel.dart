import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;
  final double fontSize;
  final double spacing;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.color = Colors.black54,
    this.iconSize = 20,
    this.fontSize = 16,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: iconSize),
        SizedBox(width: spacing),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
