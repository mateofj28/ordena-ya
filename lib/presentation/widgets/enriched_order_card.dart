import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/data/model/enriched_order_model.dart';
import 'package:ordena_ya/presentation/widgets/IconLabel.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'package:ordena_ya/presentation/widgets/ShowOrderModal.dart';
import 'package:ordena_ya/presentation/widgets/PrintOrderModal.dart';
import 'package:ordena_ya/presentation/widgets/order_card.dart';

class EnrichedOrderCard extends StatelessWidget {
  final EnrichedOrderModel order;

  const EnrichedOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final date = Functions.getDate(order.createdAt);
    final time = Functions.getTime(order.createdAt);

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
          // Encabezado con información de mesa enriquecida
          Row(
            children: [
              Text(
                _getTableDisplayText(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${order.peopleCount} Personas', 
                style: const TextStyle(fontSize: 13)
              ),
            ],
          ),
          

          
          // Fecha y hora
          Row(
            children: [
              const Icon(HugeIcons.strokeRoundedCalendar03),
              const SizedBox(width: 10),
              Text(date, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 10),
              Text(time, style: const TextStyle(fontSize: 13)),
            ],
          ),
          
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          
          // Lista de productos con información enriquecida
          ...order.requestedProducts.map((product) => _buildProductRow(product)),
          
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          
          // Total
          LabelValueRow(
            label: 'Total:',
            labelStyle: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            value: Functions.formatCurrencyINT(order.total.toInt()),
            valueStyle: TextStyle(
              fontSize: 16,
              color: AppColors.redPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          

          
          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _showOrderDetails(context),
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
                onTap: () => _printOrder(context),
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

  String _getTableDisplayText() {
    if (order.tableInfo != null && order.tableInfo!.number > 0) {
      return 'Mesa ${order.tableInfo!.number}';
    } else if (order.tableId != null && order.tableId!.isNotEmpty) {
      // FALLBACK: El backend no está enviando tableInfo enriquecida
      // Extraer número de mesa del tableId si es posible
      final tableIdShort = order.tableId!.length > 8 
          ? order.tableId!.substring(order.tableId!.length - 4)
          : order.tableId!;
      return 'Mesa $tableIdShort';
    } else {
      return _getOrderTypeDisplayText();
    }
  }

  String _getOrderTypeDisplayText() {
    switch (order.orderType) {
      case 'delivery':
        return 'Domicilio';
      case 'takeout':
        return 'Para llevar';
      default:
        return 'Mesa';
    }
  }

  Widget _buildProductRow(EnrichedOrderProduct product) {
    // Extraer los estados para mostrar
    final states = product.statusByQuantity.map((status) => status.status).toList();
    
    // Validar datos del producto
    final productName = product.productSnapshot.name.isNotEmpty 
        ? product.productSnapshot.name 
        : 'Producto sin nombre';
    final quantity = product.requestedQuantity > 0 ? product.requestedQuantity : 1;
    final unitPrice = product.productSnapshot.price >= 0 ? product.productSnapshot.price : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea principal: cantidad - nombre del producto - precio unitario
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${quantity}x $productName',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                Functions.formatCurrencyINT(unitPrice.toInt()),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          
          // Mostrar estados agrupados con colores
          if (states.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildGroupedStatusChips(states),
          ],
          
          // Nota del producto (si existe)
          if (product.message.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'Nota: ${product.message}',
              style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupedStatusChips(List<String> states) {
    // Agrupar estados por tipo y contar
    final Map<String, int> statusCount = {};
    for (final status in states) {
      final normalizedStatus = _normalizeStatus(status);
      statusCount[normalizedStatus] = (statusCount[normalizedStatus] ?? 0) + 1;
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: statusCount.entries.map((entry) {
        final status = entry.key;
        final count = entry.value;
        final displayText = count == 1 
            ? '(1) ${_getStatusDisplayText(status)}'
            : '($count) ${_getStatusDisplayTextPlural(status)}';
            
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            displayText,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }



  String _normalizeStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'pendiente';
      case 'en_preparacion':
      case 'cocinando':
        return 'cocinando';
      case 'listo_para_entregar':
      case 'listo':
        return 'listo_para_entregar';
      case 'entregado':
        return 'entregado';
      default:
        return status.toLowerCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFFFFD54F); // #FFD54F
      case 'cocinando':
      case 'en_preparacion':
        return const Color(0xFFFFB74D); // #FFB74D
      case 'listo_para_entregar':
      case 'listo':
        return const Color(0xFF29B6F6); // #29B6F6
      case 'entregado':
        return const Color(0xFF81C784); // #81C784
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'cocinando':
      case 'en_preparacion':
        return 'Cocinando';
      case 'listo_para_entregar':
      case 'listo':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregado';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }

  String _getStatusDisplayTextPlural(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendientes';
      case 'cocinando':
      case 'en_preparacion':
        return 'Cocinando';
      case 'listo_para_entregar':
      case 'listo':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregados';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }

  void _showOrderDetails(BuildContext context) {
    // Convertir a formato compatible con ShowOrderModal existente
    final orderData = {
      "tableName": _getTableDisplayText(),
      "people": order.peopleCount.toString(),
      "date": Functions.getDate(order.createdAt),
      "time": Functions.getTime(order.createdAt),
      "items": order.requestedProducts.map((product) => OrderItemRow(
        label: product.productSnapshot.name,
        value: product.productSnapshot.price * product.requestedQuantity,
        states: product.statusByQuantity.map((status) => status.status).toList(),
      )).toList(),
      "total": order.total,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowOrderModal(order: orderData);
      },
    );
  }

  void _printOrder(BuildContext context) {
    // Convertir a formato compatible con PrintOrderModal existente
    final orderData = {
      "tableName": _getTableDisplayText(),
      "people": order.peopleCount.toString(),
      "date": Functions.getDate(order.createdAt),
      "time": Functions.getTime(order.createdAt),
      "items": order.requestedProducts.map((product) => OrderItemRow(
        label: product.productSnapshot.name,
        value: product.productSnapshot.price * product.requestedQuantity,
        states: product.statusByQuantity.map((status) => status.status).toList(),
      )).toList(),
      "total": order.total,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrintOrderModal(order: orderData);
      },
    );
  }
}