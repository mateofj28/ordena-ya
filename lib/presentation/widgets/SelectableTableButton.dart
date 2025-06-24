import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:provider/provider.dart';


class SelectableTableButton extends StatelessWidget {
  final String tableName;

  const SelectableTableButton({super.key, required this.tableName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final isSelected = provider.isTableSelected(tableName);

    return GestureDetector(
      onTap: () => {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.redTotal : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Text(
          tableName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
