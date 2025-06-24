import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../../core/constants/utils/Functions.dart';
import '../providers/OrderSetupProvider.dart';
import '../widgets/CartProduct.dart';
import '../widgets/CustomButton.dart';
import '../widgets/LabelValueRow.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    int table = provider.tableIndex;
    int people = provider.peopleCount;
    double total = provider.total;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: provider.cartItems.isEmpty
          ? const EmptyCartView()
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'Resumen del pedido',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text('Mesa: $table · $people persona'),
            const SizedBox(height: 10),

            // 🧾 Lista de items del carrito
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartItems.length,
                itemBuilder: (context, index) {
                  final product = provider.cartItems[index];
                  return CartProduct(
                    product: product,
                    index: index,
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            LabelValueRow(
              label: 'Total',
              labelStyle: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              value: Functions.formatCurrency(total),
              valueStyle: TextStyle(
                fontSize: 20,
                color: AppColors.redPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
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
          HugeIcons.strokeRoundedShoppingCartRemove02,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        const Text(
          'Tu carrito está vacío',
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
