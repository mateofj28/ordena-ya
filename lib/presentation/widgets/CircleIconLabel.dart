import 'package:flutter/material.dart';

class CircleIconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function() onTap;

  const CircleIconLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.green : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
