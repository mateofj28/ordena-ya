import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/constants/AppColors.dart';
import '../../core/constants/utils/Functions.dart';
import 'IconLabel.dart';
import 'LabelValueRow.dart';

class OrderCard extends StatelessWidget {
  final String tableName;
  final String people;
  final String date;
  final String time;
  final List<OrderItemRow> items;
  final double total;

  const OrderCard({
    super.key,
    required this.tableName,
    required this.people,
    required this.date,
    required this.time,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Mesa $tableName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text('$people Personas' , style: const TextStyle(fontSize: 13)),
            ],
          ),
          Row(
            children: [
              const Icon(HugeIcons.strokeRoundedCalendar03),
              const SizedBox(width: 10),
              Text('$date,', style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 10),
              Text(time, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          // Lista dinámica
          ...items,
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          LabelValueRow(
            label: 'Total:',
            labelStyle: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            value: Functions.formatCurrency(total) ,
            valueStyle: TextStyle(
              fontSize: 16,
              color: AppColors.redPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lightGray,
                ),
                child: IconLabel(
                  icon: HugeIcons.strokeRoundedView,
                  label: 'Ver',
                  color: Colors.black,
                ),
              ),

              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lightGray,
                ),
                child: IconLabel(
                  icon: HugeIcons.strokeRoundedPrinter,
                  label: 'Imprimir',
                  color: Colors.black,
                ),
              ),

              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lightGray,
                ),
                child: IconLabel(
                  icon: HugeIcons.strokeRoundedEdit03,
                  label: 'Editar',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget para un solo ítem
class OrderItemRow extends StatelessWidget {
  final String label;
  final double value;

  const OrderItemRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              Functions.formatCurrency(value),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconLabel(
          icon: HugeIcons.strokeRoundedTrolley01,
          label: "pendent",
          color: AppColors.yellowStatus,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Widget para los íconos de acción
/* class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const IconLabelButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}*/
