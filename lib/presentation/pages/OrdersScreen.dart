import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../providers/OrderSetupProvider.dart';
import '../widgets/CustomButton.dart';
import '../widgets/OrderCard.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: provider.cartItems.isEmpty
          ? const EmptyCartView()
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 Lista de items del carrito
            Expanded(
              child: ListView.builder(
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return OrderCard(
                    tableName: product['name'],
                    people: product['people'],
                    date: product['date'],
                    time: product['time'],
                    total: product['total'],
                    items: const [
                      OrderItemRow(
                        label: "1 x Nachos con Guacamole",
                        value: 18500,
                      ),
                      OrderItemRow(
                        label: "2 x Coca Cola",
                        value: 5000,
                      ),
                      // ... más items aquí
                    ],
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
    final provider = Provider.of<OrderSetupProvider>(context, listen: false);

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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Agregue productos desde la pestaña de Productos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        CustomButton(
          label: 'Ir a Productos',
          baseColor: AppColors.redPrimary,
          textColor: Colors.white,
          onTap: () {
            provider.updateMenu(1);
          },
        )
      ],
    );
  }
}
