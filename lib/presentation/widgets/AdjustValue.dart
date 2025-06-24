import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:provider/provider.dart';
import '../providers/OrderSetupProvider.dart';

class AdjustValue extends StatelessWidget {
  final String label;
  final int index;
  final Function() increase;
  final Function() decrease;

  const AdjustValue({
    super.key,
    required this.label,
    required this.index,
    required this.increase,
    required this.decrease,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.lightGray,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: decrease,
                icon: Icon(HugeIcons.strokeRoundedRemove01),
              ),
              Text(index.toString()),
              IconButton(
                onPressed: increase,
                icon: Icon(HugeIcons.strokeRoundedAdd01),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
