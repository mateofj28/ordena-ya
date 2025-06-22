import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../providers/OrderSetupProvider.dart';
import '../widgets/CartProduct.dart';
import '../widgets/LabelValueRow.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Scaffold(
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
            const Text('Mesa: 1 · 1 persona'),
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
              value: '34.000',
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          HugeIcons.strokeRoundedShoppingCartRemove02,
          size: 80,
          color: Colors.grey[600],
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
        ElevatedButton(
          onPressed: () {
            provider.updateIndex(0); // Redirige a la pestaña de productos
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Ver productos',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
