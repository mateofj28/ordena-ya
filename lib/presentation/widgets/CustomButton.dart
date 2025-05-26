import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:provider/provider.dart';



class CustomButton extends StatelessWidget {
  final String label;
  final Color baseColor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.label,
    required this.baseColor,
    required this.onTap,
  });

  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color _getPressedColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.light
        ? darken(color, 0.2)
        : lighten(color, 0.2);
  }

  @override
  Widget build(BuildContext context) {
    final isPressed = context.watch<ToggleButtonProvider>().isPressed;
    final currentColor = isPressed ? _getPressedColor(baseColor) : baseColor;

    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => context.read<ToggleButtonProvider>().setPressed(true),
      onTapUp: (_) => context.read<ToggleButtonProvider>().setPressed(false),
      onTapCancel: () => context.read<ToggleButtonProvider>().setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black, // aquí puedes ajustar el color de texto si quieres
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
