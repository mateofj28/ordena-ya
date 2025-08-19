import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/widgets/OrdersList.dart';
import 'package:provider/provider.dart';

class ViewAllOrders extends StatelessWidget {
  const ViewAllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Scaffold(
      body:
          provider.isLoadingAllOrders
              ? const Center(child: CircularProgressIndicator())
              : provider.orders.isEmpty
              ? const Center(child: Text('No hay órdenes registradas.'))
              : OrdersList(orders: provider.orders),
    );
  }
}
