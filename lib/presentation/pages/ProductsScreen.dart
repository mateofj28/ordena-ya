import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/CircleIconLabel.dart';
import 'package:provider/provider.dart';

import '../providers/OrderSetupProvider.dart';
import '../widgets/ProductListItem.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  final List<Map<String, dynamic>> options = [
    {"icon": HugeIcons.strokeRoundedIceCubes, "label": 'Todos'},
    {"icon": HugeIcons.strokeRoundedServingFood, "label": 'Entradas'},
    {"icon": HugeIcons.strokeRoundedNoodles, "label": 'Platos'},
    {"icon": HugeIcons.strokeRoundedIceCream01, "label": 'Postres'},
    {"icon": HugeIcons.strokeRoundedSoftDrink02, "label": 'Bebidas'},
  ];

  final List<Map<String, dynamic>> allProducts = [
    {
      "imageUrl": "https://wallpaperaccess.com/full/767277.jpg",
      "title": "Hamburguesa",
      "price": "\$25.000",
      "time": "15 min",
      "category": "Platos",
    },
    {
      "imageUrl": "https://wallpaperaccess.com/full/767278.jpg",
      "title": "Gaseosa",
      "price": "\$5.000",
      "time": "1 min",
      "category": "Bebidas",
    },
    {
      "imageUrl": "https://wallpaperaccess.com/full/767279.jpg",
      "title": "Helado",
      "price": "\$8.000",
      "time": "5 min",
      "category": "Postres",
    },
    // Agrega más productos con su categoría...
  ];

  List<Map<String, dynamic>> getFilteredProducts(int selectedIndex) {
    if (selectedIndex == 0) return allProducts;

    final selectedLabel = options[selectedIndex]['label'];
    return allProducts.where((p) => p['category'] == selectedLabel).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final filteredProducts = getFilteredProducts(provider.currentMenu);

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(options.length, (index) {
              return CircleIconLabel(
                icon: options[index]['icon'],
                label: options[index]['label'],
                isSelected: provider.currentMenu == index,
                onTap: () {
                  provider.updateMenu(index);
                },
              );
            }),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductListItem(
                    imageUrl: product['imageUrl'],
                    title: product['title'],
                    price: product['price'],
                    estimatedTime: product['time'],
                    onAdd: () {
                      // Lógica para agregar al carrito
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
