import 'package:flutter/material.dart';

import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/domain/entity/order.dart';


class OrdersList extends StatelessWidget {
  final List<Order> orders;

  const OrdersList({super.key, required this.orders});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return AppColors.deliveredColor;
      case 'pendiente':
        return AppColors.pendingColor;
      case 'preparado':
        return AppColors.preparedColor;
      default:
        return Colors
            .grey
            .shade200; // Valor por defecto si el estado no es reconocido
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        // final order = orders[index]; // Commented out since not currently used

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GestureDetector(
            onTap: () {
              // Navegar a detalles, si aplica
            },
            /*
            OrderSummaryCard(
              orderId: order.orderNumber,
              table:
                  order.assignedTable?.isNotEmpty == true
                      ? '${order.assignedTable}'
                      : 'Sin mesa',
              consumptionType: order.deliveryType,
              paymentMethod: order.paymentMethod,
              date: DateFormat('dd/MM/yyyy – hh:mm a').format(order.orderDate),
              status: order.orderStatus,
              total: order.totalValue,
              headerColor: getStatusColor(order.orderStatus),*/

            child: Container()
          ),
        );
      },
    );
  }
}
