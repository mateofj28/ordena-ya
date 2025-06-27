import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/CircleIconLabel.dart';
import 'package:ordena_ya/presentation/widgets/ProductModal.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
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
      "price": 25000.0,
      "time": "15 min",
      "category": "Platos",
    },
    {
      "imageUrl": "https://wallpaperaccess.com/full/767278.jpg",
      "title": "Gaseosa",
      "price": 5000.0,
      "time": "1 min",
      "category": "Bebidas",
    },
    {
      "imageUrl": "https://wallpaperaccess.com/full/767279.jpg",
      "title": "Helado",
      "price": 8000.0,
      "time": "5 min",
      "category": "Postres",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1586190848861-99aa4a171e90",
      "title": "Pizza",
      "price": 30000.0,
      "time": "20 min",
      "category": "Platos",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1564758866819-83c2b5cd2e84",
      "title": "Cerveza",
      "price": 7000.0,
      "time": "1 min",
      "category": "Bebidas",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1603079832603-08d628f7f87f",
      "title": "Brownie con helado",
      "price": 12000.0,
      "time": "7 min",
      "category": "Postres",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1571091718767-18b5b1457add",
      "title": "Ensalada César",
      "price": 18000.0,
      "time": "10 min",
      "category": "Platos",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1585238342028-031c4a7763b3",
      "title": "Jugo natural",
      "price": 6000.0,
      "time": "3 min",
      "category": "Bebidas",
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1578985545062-69928b1d9587",
      "title": "Torta de chocolate",
      "price": 10000.0,
      "time": "6 min",
      "category": "Postres",
    },
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
              color: AppColors.lightGray,
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductModal(
                            productImage: product['imageUrl'],
                            productName: product['title'],
                            description: 'Deliciosa pizza con salsa de tomate fresca, mozzarella de búfala, albahaca fresca y aceite de oliva extra virgen.',
                            price: product['price'],
                            preparationTime: product['time'],
                          );
                        },
                      );
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
