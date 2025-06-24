import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';

class BadgeContainer extends StatelessWidget {
  final String title;
  final bool showBadge; // Controla si se debe mostrar el badge
  final int badgeCount;
  final bool isSelected;
  final Function() onTap;

  // Constructor
  const BadgeContainer({super.key,
    required this.title,
    this.showBadge = false, // Por defecto no mostrar el badge
    this.badgeCount = 0,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final color = isSelected ? AppColors.redPrimary : Colors.grey[300];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Texto principal (por ejemplo, "Productos")
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            // Si se debe mostrar el badge, lo agregamos en la esquina superior derecha
            if (showBadge && badgeCount > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
