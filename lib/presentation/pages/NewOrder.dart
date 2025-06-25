import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/pages/CartScreen.dart';
import 'package:ordena_ya/presentation/pages/OrdersScreen.dart';
import 'package:ordena_ya/presentation/pages/ProductsScreen.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';

import 'package:ordena_ya/presentation/widgets/AdjustValue.dart';
import 'package:ordena_ya/presentation/widgets/BadgeContainer.dart';
import 'package:ordena_ya/presentation/widgets/SelectableCard.dart';
import 'package:provider/provider.dart';

class NewOrder extends StatelessWidget {
  NewOrder({super.key, required this.product});

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

  final List<Color> _pageColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  final PageController _pageController = PageController();

  final List _pages = [
    ProductsScreen(),
    CartScreen(),
    OrdersScreen()
  ];

  final List<Map<String, dynamic>> options = [
    {"icon": HugeIcons.strokeRoundedHome07, "label": 'Mesa'},
    {"icon": HugeIcons.strokeRoundedDeliveryTruck01, "label": 'Domicilio'},
    {"icon": HugeIcons.strokeRoundedPackage, "label": 'Para llevar'},
  ];

  final List<String> titles = ['Productos', 'Carrito', 'Pedidos'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final selectedIndex = provider.selectedIndex;
    final tableIndex = provider.tableIndex;
    final peopleIndex = provider.peopleCount;
    final step = provider.discountStep;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                AdjustValue(
                  label: 'Mesa',
                  index: tableIndex,
                  increase: () => provider.increaseTable(),
                  decrease: () => provider.decreaseTable(),
                ),
                AdjustValue(
                  label: 'Personas',
                  index: peopleIndex,
                  increase: () => provider.increasePeople(),
                  decrease: () => provider.decreasePeople(),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;

              return SelectableCard(
                icon: options[index]['icon'],
                title: options[index]['label'],
                index: index,
                isSelected: isSelected,
              );
            }),
          ),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(titles.length, (index) {
              return BadgeContainer(
                title: titles[index],
                isSelected: provider.currentIndex == index,
                showBadge: index == 1 && provider.cartItems.isNotEmpty || index == 2 && provider.orders.isNotEmpty,
                badgeCount: index == 1
                    ? provider.cartItems.length
                    : index == 2
                    ? provider.orders.length
                    : 0,
                onTap: () {
                  provider.updateIndex(index);
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              );
            }),
          ),



          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
              onPageChanged: (index) {
                provider.updateIndex(index);
              },
            ),
          ),
        ],
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
