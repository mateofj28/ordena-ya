import 'package:flutter/material.dart';

class BadgeContainer extends StatelessWidget {
  final String title;
  final bool showBadge; // Controla si se debe mostrar el badge
  final int badgeCount; // El número que se muestra en el badge

  // Constructor
  BadgeContainer({
    required this.title,
    this.showBadge = false, // Por defecto no mostrar el badge
    this.badgeCount = 0, // El conteo del badge (si está habilitado)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Texto principal (por ejemplo, "Productos")
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
