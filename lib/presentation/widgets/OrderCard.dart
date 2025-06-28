import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/ShowOrderModal.dart';

import '../../core/constants/AppColors.dart';
import '../../core/constants/utils/Functions.dart';
import 'IconLabel.dart';
import 'LabelValueRow.dart';
import 'PrintOrderModal.dart';

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
              Text('$people Personas', style: const TextStyle(fontSize: 13)),
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
            value: Functions.formatCurrency(total),
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
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final order = {
                        "tableName": tableName,
                        "people": people,
                        "date": date,
                        "time": time,
                        "items": items,
                        "total": total,
                      };

                      return ShowOrderModal(order: order);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              ),

              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final order = {
                        "tableName": tableName,
                        "people": people,
                        "date": date,
                        "time": time,
                        "items": items,
                        "total": total,
                      };

                      return PrintOrderModal(order: order);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
  final String state;

  const OrderItemRow({
    super.key,
    required this.label,
    required this.value,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final config = getStateUIConfig(state);
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
          icon: config.icon,
          label: config.label,
          color: config.color,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class StateUIConfig {
  final IconData icon;
  final String label;
  final Color color;

  const StateUIConfig({
    required this.icon,
    required this.label,
    required this.color,
  });
}

StateUIConfig getStateUIConfig(String state) {
  switch (state) {
    case 'pendiente':
      return StateUIConfig(
        icon: HugeIcons.strokeRoundedTrolley01,
        label: 'pendiente',
        color: AppColors.yellowStatus,
      );
    case 'en preparación':
      return StateUIConfig(
        icon: HugeIcons.strokeRoundedPackageProcess,
        label: 'en preparación',
        color: AppColors.redPrimary,
      );
    case 'listo para entregar':
      return StateUIConfig(
        icon: HugeIcons.strokeRoundedTrolley02,
        label: 'Ready to Deliver',
        color: Colors.yellow,
      );
    case 'entregado':
      return StateUIConfig(
        icon: HugeIcons.strokeRoundedPackageDelivered,
        label: 'entregado',
        color: Colors.green,
      );
    default:
      return StateUIConfig(
        icon: Icons.help_outline,
        label: 'Unknown',
        color: Colors.grey,
      );
  }
}
