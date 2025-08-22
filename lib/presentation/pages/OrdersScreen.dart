import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../providers/order_provider.dart';
import '../widgets/CustomButton.dart';
import '../widgets/OrderCard.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body:
          provider.orders.isEmpty
              ? const EmptyCartView()
              : Padding(
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
                          print("la orden es:");
                          print(order);

                          return OrderCard(
                            people: "2",
                            items: [],
                            order: order,
                          );
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
