import 'package:flutter/material.dart';

class IconSubtitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final double? iconSize;
  final TextStyle? textStyle;

  const IconSubtitle({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Icon(icon, size: iconSize ?? 25, color: color ?? Colors.black),
        const SizedBox(width: 8),
        Text(
          text,
          style: textStyle ?? Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
