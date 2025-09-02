import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../providers/order_provider.dart';
import '../widgets/CustomButton.dart';
import '../widgets/OrderCard.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<OrderSetupProvider>(context, listen: false).getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    if (provider.status == OrderStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.status == OrderStatus.error) {
      return Scaffold(body: Center(child: Text(provider.errorMessage)));
    }

    if (provider.status == OrderStatus.success && provider.orders.isEmpty) {
      return EmptyCartView();
    }

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Lista de items del carrito
            Expanded(
              child: ListView.builder(
                itemCount: provider.orders.length,
                itemBuilder: (context, index) {
                  final order = provider.orders[index];
                  // print("la orden es:");

                  List<OrderItemRow> items =
                      order.items!
                          .map(
                            (item) => OrderItemRow(
                              label: '${item.quantity} x ${item.productName}',
                              value: item.price * item.quantity,
                              states:
                                  item.units
                                      .map((units) => units.status)
                                      .toList(),
                            ),
                          )
                          .toList();

                  return OrderCard(people: "2", items: items, order: order);
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          HugeIcons.strokeRoundedShoppingBasketRemove03,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        const Text(
          'No hay pedidos activos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Agregue productos desde la pestaña de Productos',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        CustomButton(
          label: 'Ir a Productos',
          baseColor: AppColors.redPrimary,
          textColor: Colors.white,
          onTap: () {
            provider.updateMenu(0);
            provider.goToPage(0);
          },
        ),
      ],
    );
  }
}
