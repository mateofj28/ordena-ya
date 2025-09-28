import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/content/show_available_table.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/providers/tables_provider.dart';
import 'package:ordena_ya/presentation/widgets/RegisterClientModal.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';

class SelectableCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final bool isSelected;
  final double width;
  final double height;

  const SelectableCard({
    super.key,
    required this.icon,
    required this.title,
    this.width = 110,
    this.height = 100,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderSetupProvider>(
      builder: (context, selectionModel, child) {
        return GestureDetector(
          onTap: () {
            selectionModel.select(index);
            if (index == 0) {
              context.read<TablesProvider>().getTables();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShowAvailableTable();
                },
              );
            }

            if (index == 1) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RegisterClientModal();
                },
              );
            }
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.redPrimary : AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.black),
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
