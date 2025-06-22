import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'package:provider/provider.dart';

import '../providers/OrderSetupProvider.dart';
import '../widgets/IconLabel.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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


            // 🧾 Lista de items del carrito
            /*Expanded(
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
            ),*/

            Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[100]
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Mesa 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text('2 Personas', style: TextStyle(fontSize: 13))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(HugeIcons.strokeRoundedCalendar03),
                      SizedBox(width: 10),
                      Text('21/6/2025,', style: TextStyle(fontSize: 13)),
                      SizedBox(width: 10),

                      Text('7:34 pm', style: TextStyle(fontSize: 13)),

                    ],
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 20,
                  ),

                  LabelValueRow(label: "1 x Nachos con Guacamole", value: "18.500"),


                  Row(
                    children: [
                      IconLabel(
                        icon: Icons.shopping_cart,
                        label: 'Carrito',
                        color: Colors.blue,
                      ),
                    ],
                  ),




                ],
              ),
            )


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
          HugeIcons.strokeRoundedShoppingBasketRemove03,
          size: 80,
          color: Colors.grey[600],
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
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            provider.updateIndex(0);
          },
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
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

