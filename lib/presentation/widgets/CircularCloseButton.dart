import 'package:flutter/material.dart';

class CircularCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;

  const CircularCloseButton({
    super.key,
    required this.onPressed,
    this.size = 30,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.iconColor = Colors.black,
    this.icon = Icons.close,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: size / 1.5,
        onPressed: onPressed,
        icon: Icon(icon, size: size * 0.65, color: iconColor),
      ),
    );
  }
}
