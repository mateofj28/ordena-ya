import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/providers/tables_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/AppColors.dart';
import '../../core/utils/functions.dart';
import '../providers/order_provider.dart';
import '../widgets/CartProduct.dart';
import '../widgets/custom_button.dart';
import '../widgets/LabelValueRow.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderSetupProvider>(context);
    final tableProvider = Provider.of<TablesProvider>(context);

    int table = tableProvider.table != null ? tableProvider.table!.id : 0;
    int people = orderProvider.peopleCount;
    double total = orderProvider.total;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: orderProvider.cartItems.isEmpty
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

            if (table != 0 && people != 1)
              Text('Mesa: $table · $people persona'),
              const SizedBox(height: 10),

            // 🧾 Lista de items del carrito
            Expanded(
              child: ListView.builder(
                itemCount: orderProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final product = orderProvider.cartItems[index];
                  return CartProduct(
                    product: product,
                    index: index,
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            LabelValueRow(
              label: 'Impuesto al consumo',
              labelStyle: TextStyle(

                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              value: "8%",
              valueStyle: TextStyle(

                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
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
    final provider = Provider.of<OrderSetupProvider>(context);

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
            provider.updateMenu(0);
            provider.goToPage(0);
          },
        )
      ],
    );
  }
}
