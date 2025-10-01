


import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class StatusDisplay extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final IconData iconButton;
  final String labelButton;
  final Color backgroundColorButton;
  final bool showTitle;
  final bool showAction;
  final Color foregroundColorButton;
  final String message;
  final VoidCallback onAction;

  const StatusDisplay({
    super.key,
    required this.iconColor,
    required this.message,
    required this.icon,
    required this.onAction, 
    required this.iconButton, 
    required this.labelButton, 
    required this.backgroundColorButton, 
    this.showTitle = true,
    this.showAction = true,
    required this.foregroundColorButton,
  });

  // 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [        
            HugeIcon(
              color: iconColor,
              size: 64,
              icon: icon,
            ),
            const SizedBox(height: 16),
            if (showTitle)
              Text(
                "Estado Actual",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            if (showAction)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(iconButton), // Ejemplo: 
                label: Text(labelButton), // Ejemplo: "Reintentar"
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColorButton, // Ejemplo: Colors.redAccent
                  foregroundColor: foregroundColorButton // Ejemplo: Colors.white
                ),
              ),
          ],
        ),
      ),
    );
  }
}

