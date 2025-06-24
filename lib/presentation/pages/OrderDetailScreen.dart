import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:ordena_ya/presentation/widgets/DetailsItemCard.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  // List<Map<String, dynamic>> cartItems = [
  //   {"name": "Taco al Pastor", "price": 14500},
  //   {"name": "Burrito de Carne", "price": 16000},
  //   {"name": "Nachos con Guacamole", "price": 9500},
  //   {"name": "Cerveza Artesanal", "price": 7500},
  //   {"name": "Churros con Chocolate", "price": 8500},
  // ];

  OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    var items = provider.cartItems;
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(title: Text("Detalle del pedido"), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 20),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.textPrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_bar, size: 40),
                      Text("Mesa 5", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.groups, size: 40),
                      Text("Grupo", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
      
          SizedBox(height: 10),
      
          SizedBox(
            height: 342,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemCard(
                  name: item['name'],
                  price: item['price'],
                  index: index,
                  onRemove: () {},
                );
              },
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.receipt_long, size: 24),
                SizedBox(width: 8), // Espacio entre ícono y texto
                Text(
                  "Pre-factura",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      
          LabelValueRow(label: "Subtotal:", value: "\$80.00"),
          LabelValueRow(label: "IVA (16%):", value: "\$12.50"),
          LabelValueRow(label: "Servicio(10%):", value: "\$8.50"),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 24,
            ),
          ),
      
          LabelValueRow(
            label: "Total:",
            value: "\$100.80",
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            valueStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.redTotal,
            ),
          ),
      
          SizedBox(height: 15),
      
          CustomButton(
            label: "Enviar a caja",
            textColor: Colors.white,

            baseColor:
                AppColors
                    .redTotal, // oscuro → se aclarará al presionar
            onTap: () {},
          ),
      
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
