import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:provider/provider.dart';


class SelectableCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double width;
  final double height;

  SelectableCard({
    required this.icon,
    required this.title,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderSetupProvider>(
      builder: (context, selectionModel, child) {
        bool isSelected = selectionModel.isSelected(title);

        return GestureDetector(
          onTap: () {
            selectionModel.toggleSelection(title); // Cambiar el estado de selección
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
