import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';

class OrderCardNew extends StatelessWidget {
  final OrderResponseEntity order;
  final VoidCallback? onTap;

  const OrderCardNew({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con mesa y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HugeIcon(
                              icon: _getTableIcon(),
                              color: AppColors.redPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mesa ${order.mesa}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${order.cantidadPersonas} personas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order.estadoDisplay,
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Información del pedido
              Row(
                children: [
                  HugeIcon(
                    icon: _getTipoPedidoIcon(),
                    color: Colors.grey[600]!,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order.tipoDisplay,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingBag01,
                    color: Colors.grey[600]!,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${order.totalProductos} productos',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Productos (máximo 2 visibles)
              ...order.productosSolicitados.take(2).map((producto) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${producto.cantidadSolicitada}x ${producto.nombreProducto}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        producto.estadoPrincipal,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getProductStatusColor(producto.estadoPrincipal),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Mostrar "y X más" si hay más productos
              if (order.productosSolicitados.length > 2)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Text(
                    'y ${order.productosSolicitados.length - 2} más...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Footer con total y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Functions.formatCurrency(order.total),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redPrimary,
                    ),
                  ),
                  Text(
                    Functions.getTime(order.fechaCreacion),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTableIcon() {
    switch (order.tipoPedido.toLowerCase()) {
      case 'mesa':
        return HugeIcons.strokeRoundedHome07;
      case 'domicilio':
        return HugeIcons.strokeRoundedDeliveryTruck01;
      case 'recoger':
        return HugeIcons.strokeRoundedPackage;
      default:
        return HugeIcons.strokeRoundedHome07;
    }
  }

  IconData _getTipoPedidoIcon() {
    switch (order.tipoPedido.toLowerCase()) {
      case 'mesa':
        return HugeIcons.strokeRoundedRestaurant01;
      case 'domicilio':
        return HugeIcons.strokeRoundedDeliveryTruck01;
      case 'recoger':
        return HugeIcons.strokeRoundedPackage;
      default:
        return HugeIcons.strokeRoundedRestaurant01;
    }
  }

  Color _getStatusColor() {
    switch (order.estadoGeneral.toLowerCase()) {
      case 'recibida':
        return Colors.blue;
      case 'cocinando':
        return Colors.orange;
      case 'lista':
        return Colors.green;
      case 'entregada':
        return Colors.grey;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProductStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'recibida':
        return Colors.blue;
      case 'en cocina':
        return Colors.orange;
      case 'lista':
        return Colors.green;
      case 'entregada':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}