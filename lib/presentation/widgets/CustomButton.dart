import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/Functions.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:provider/provider.dart';



class CustomButton extends StatelessWidget {
  final String label;
  final Color baseColor;
  final Color textColor;

  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.label,
    required this.baseColor,
    required this.textColor,
    required this.onTap,
  });

  
  @override
  Widget build(BuildContext context) {
    // final isPressed = context.watch<ToggleButtonProvider>().isPressed;
    // final currentColor = isPressed ? Functions.getPressedColor(baseColor) : baseColor;

    return ChangeNotifierProvider(
      create: (_) => ToggleButtonProvider(),
      child: Consumer<ToggleButtonProvider>(
        builder: (context, toggleProvider, child) {
          final currentColor = toggleProvider.isPressed
              ? Functions.getPressedColor(baseColor)
              : baseColor;

          return GestureDetector(
            onTap: onTap,
            onTapDown: (_) => toggleProvider.setPressed(true),
            onTapUp: (_) => toggleProvider.setPressed(false),
            onTapCancel: () => toggleProvider.setPressed(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: const EdgeInsets.symmetric(horizontal: 77, vertical: 12),
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
