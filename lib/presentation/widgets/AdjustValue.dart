import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';

class AdjustValue extends StatelessWidget {
  final String label;
  final int index;
  final Function() increase;
  final Function() decrease;
  final bool canDecrease; // Nueva propiedad para validar si se puede decrementar
  final bool canIncrease; // Nueva propiedad para validar si se puede incrementar

  const AdjustValue({
    super.key,
    required this.label,
    required this.index,
    required this.increase,
    required this.decrease,
    this.canDecrease = true, // Por defecto permitido para compatibilidad
    this.canIncrease = true, // Por defecto permitido para compatibilidad
  });

  @override
  Widget build(BuildContext context) {
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
                onPressed: canDecrease && index > 1 ? () {
                  print('🔽 DECREASE BUTTON PRESSED - canDecrease: $canDecrease, index: $index');
                  decrease();
                } : null,
                icon: Icon(
                  HugeIcons.strokeRoundedRemove01,
                  color: canDecrease && index > 1 
                      ? Colors.black 
                      : Colors.grey[400],
                ),
              ),
              Text(index.toString()),
              IconButton(
                onPressed: canIncrease ? increase : null,
                icon: Icon(
                  HugeIcons.strokeRoundedAdd01,
                  color: canIncrease 
                      ? Colors.black 
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
