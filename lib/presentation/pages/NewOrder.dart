import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import 'package:ordena_ya/presentation/pages/OrderSetupScreen.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueColumn.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'package:ordena_ya/presentation/widgets/OrderProduct.dart';
import 'package:provider/provider.dart';

class NewOrder extends StatelessWidget {
  NewOrder({required this.product});

  final Product product;

  String deliveryTypeToString(int type) {
    switch (type) {
      case 0:
        return 'En el lugar';
      case 1:
        return 'domicilio';
      case 2:
        return 'Para recoger';
      default:
        return 'Tipo desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderSetupProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangeNotifierProvider(
              create: (_) => ToggleButtonProvider(),
              child: Consumer<ToggleButtonProvider>(
                builder: (context, toggleProvider, child) {
                  final currentColor =
                      toggleProvider.isPressed
                          ? Functions.getPressedColor(AppColors.subButton)
                          : AppColors.subButton;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Functions.navigateWithSlideUp(
                          context,
                          OrderSetupScreen(),
                        );
                      },
                      onTapDown: (_) => toggleProvider.setPressed(true),
                      onTapUp: (_) => toggleProvider.setPressed(false),
                      onTapCancel: () => toggleProvider.setPressed(false),
                      child: Container(
                        height: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LabelValueColumn(
                                  title: 'Entrega', // Para el tipo de entrega
                                  value:
                                      cart.deliveryType == 0
                                          ? 'Recoger en tienda'
                                          : deliveryTypeToString(
                                            cart.deliveryType,
                                          ),
                                ),

                                SizedBox(height: 10),

                                LabelValueColumn(
                                  title: 'Mesa', // Para la mesa seleccionada
                                  value: cart.selectedTable,
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LabelValueColumn(
                                  title:
                                      'Personas', // Para cantidad de personas
                                  value: cart.selectedPeople,
                                ),

                                SizedBox(height: 10),

                                LabelValueColumn(
                                  title: 'Cliente', // Para cliente seleccionado
                                  value:
                                      cart.selectedClient.isNotEmpty
                                          ? cart.selectedClient
                                          : 'Sin cliente',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 300,
              child: Consumer<OrderSetupProvider>(
                builder: (context, cart, _) {
                  final products = cart.cartItems;

                  if (products.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedPackage,
                          size: 50,
                          color: AppColors.text,
                        ),

                        Text(
                          'No hay productos en el pedido',
                          style: TextStyle(fontSize: 16, color: AppColors.text),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return OrderProduct(
                        product: products[index],
                        index: index,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Encabezado
            CustomButton(
              label: 'Agregar descuento',
              baseColor: AppColors.subButton,
              onTap: () {},
            ),

            const SizedBox(height: 20),

            LabelValueRow(
              label: 'Artículos',
              value: cart.totalItems.toString(),
              valueStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.text,
              ),
            ),
            LabelValueRow(
              label: 'Subtotal',
              value:
                  cart.subtotal == 0
                      ? '0.00'
                      : Functions.formatCurrency(cart.subtotal),

              valueStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.text,
              ),
            ),
            LabelValueRow(label: 'Impuesto al consumo', value: '(8%)'),
            LabelValueRow(
              label: 'Total',
              value: Functions.formatCurrency(cart.total),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: 'Cuenta',
                  baseColor: AppColors.primaryButton,
                  onTap: () {},
                ),

                CustomButton(
                  label: 'Factura y pago',
                  baseColor: AppColors.subButton,
                  onTap: () {
                    cart.createOrder(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            CustomButton(
              label: 'Facturar e imprimir recibo',
              baseColor: AppColors.tertiaryButton,
              onTap: () {},
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Functions.navigateWithSlideUp(context, MenuScreen());
        },
        tooltip: 'Agregar producto',
        backgroundColor: AppColors.primaryButton,
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedPackageAdd,
          color: Colors.black,
        ),
      ),
    );
  }
}

class Product {
  final String name;
  int quantity;
  final int price;

  Product({required this.name, this.quantity = 1, required this.price});

  int get total => price * quantity;
}
