import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:provider/provider.dart';
import '../../core/constants/AppColors.dart';
import '../../core/utils/functions.dart';
import '../providers/order_provider.dart';
import '../widgets/CartProduct.dart';
import '../widgets/custom_button.dart';
import '../widgets/LabelValueRow.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh automático al entrar al carrito
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCart();
    });
  }

  Future<void> _refreshCart() async {
    final provider = Provider.of<OrderSetupProvider>(context, listen: false);
    await provider.refreshCartStatesFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderSetupProvider>(
      builder: (context, provider, child) {
        
        // Información de la orden
        String orderInfo = '';
        switch (provider.selectedIndex) {
          case 0:
            if (provider.selectedTableInfo != null) {
              final table = provider.selectedTableInfo!;
              orderInfo = 'Mesa ${table.tableNumber} (${table.location}) · ${provider.peopleCount} personas';
            } else {
              orderInfo = 'Mesa: ${provider.tableId} · ${provider.peopleCount} personas';
            }
            break;
          case 1:
            orderInfo = 'Domicilio · Cliente: ${provider.clientId}';
            break;
          case 2:
            orderInfo = 'Para recoger';
            break;
        }

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          body: provider.newCartItems.isEmpty
              ? const EmptyCartView()
              : RefreshIndicator(
                  onRefresh: _refreshCart,
                  child: Padding(
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

                        if (orderInfo.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            orderInfo,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 10),

                        // Lista de items del carrito usando el diseño original
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(), // Permite scroll para refresh
                            itemCount: provider.newCartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = provider.newCartItems[index];
                              return CartProduct(
                                cartItem: cartItem,
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
                          value: Functions.formatCurrencyINT(provider.cartTotal.toInt()),
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
                ),
        );
      },
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
