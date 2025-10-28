import 'package:flutter/material.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/presentation/widgets/order_card.dart';

class NewOrderCard extends StatelessWidget {
  final OrderResponseEntity order;

  const NewOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    // Convertir los productos solicitados a OrderItemRow
    final items = order.productosSolicitados.map((producto) {
      // Extraer los estados de cada cantidad
      final states = producto.estadosPorCantidad.map((estado) => estado.estado).toList();
      
      return OrderItemRow(
        label: producto.nombreProducto,
        value: producto.price * producto.cantidadSolicitada, // Precio total del producto
        states: states,
      );
    }).toList();

    // Crear un Order compatible para OrderCard existente
    final mockOrder = Order(
      orderId: order.id,
      tenantId: '1',
      tableId: order.mesa.toString(),
      peopleCount: order.cantidadPersonas,
      consumptionType: order.tipoPedido,
      status: order.estadoGeneral,
      createdAt: order.fechaCreacion,
      total: order.total,
      subtotal: order.total * 0.92, // Aproximación sin impuestos
      tax: order.total * 0.08, // Aproximación de impuestos
    );

    return OrderCard(
      people: order.cantidadPersonas.toString(),
      items: items,
      order: mockOrder,
    );
  }
}