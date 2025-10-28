import 'package:flutter/material.dart';


class SelectableTableButton extends StatelessWidget {
  final String tableName;

  const SelectableTableButton({super.key, required this.tableName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        // TODO: Implement table selection
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Always use default color for now
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text(
          tableName,
          style: TextStyle(
            color: Colors.black, // Always use default color for now
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
