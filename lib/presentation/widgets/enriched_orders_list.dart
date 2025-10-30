import 'package:flutter/material.dart';
import 'package:ordena_ya/data/model/enriched_order_model.dart';
import 'package:ordena_ya/presentation/widgets/enriched_order_card.dart';

class EnrichedOrdersList extends StatelessWidget {
  final List<EnrichedOrderModel> orders;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const EnrichedOrdersList({
    super.key,
    required this.orders,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar órdenes',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (onRefresh != null)
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Reintentar'),
              ),
          ],
        ),
      );
    }

    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay órdenes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Las órdenes aparecerán aquí cuando se creen',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return EnrichedOrderCard(order: order);
        },
      ),
    );
  }
}

// Widget de ejemplo para mostrar estadísticas de órdenes usando la información enriquecida
class OrdersStatsWidget extends StatelessWidget {
  final List<EnrichedOrderModel> orders;

  const OrdersStatsWidget({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    final totalOrders = orders.length;
    final totalRevenue = orders.fold<double>(0, (sum, order) => sum + order.total);
    final tableOrders = orders.where((order) => order.orderType == 'table').length;
    final deliveryOrders = orders.where((order) => order.orderType == 'delivery').length;
    final takeoutOrders = orders.where((order) => order.orderType == 'takeout').length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas de Órdenes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', totalOrders.toString(), Icons.receipt),
                _buildStatItem('Mesa', tableOrders.toString(), Icons.table_restaurant),
                _buildStatItem('Domicilio', deliveryOrders.toString(), Icons.delivery_dining),
                _buildStatItem('Para llevar', takeoutOrders.toString(), Icons.takeout_dining),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: _buildStatItem(
                'Ingresos Total', 
                '\$${totalRevenue.toStringAsFixed(2)}', 
                Icons.attach_money,
                isLarge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {bool isLarge = false}) {
    return Column(
      children: [
        Icon(
          icon,
          size: isLarge ? 32 : 24,
          color: Colors.blue,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 14 : 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}