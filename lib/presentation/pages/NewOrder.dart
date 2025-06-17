import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import 'package:ordena_ya/presentation/pages/OrderSetupScreen.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:ordena_ya/presentation/widgets/AdjustValue.dart';
import 'package:ordena_ya/presentation/widgets/BadgeContainer.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:ordena_ya/presentation/widgets/CustomDropDown.dart';
import 'package:ordena_ya/presentation/widgets/IconActionButton.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueColumn.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'package:ordena_ya/presentation/widgets/OrderProduct.dart';
import 'package:ordena_ya/presentation/widgets/SelectableCard.dart';
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

  final List<Color> _pageColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  final PageController _pageController = PageController();

  final List<String> _pageTitles = [
    'Página 1',
    'Página 2',
    'Página 3',
    'Página 4',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderSetupProvider>(context);
    final step = cart.discountStep;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AdjustValue(label: 'Mesa:'),
              AdjustValue(label: 'Personas:'),
            ],
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectableCard(
                icon: HugeIcons.strokeRoundedHome07,
                title: 'Mesa',
              ),
              SelectableCard(
                icon: HugeIcons.strokeRoundedDeliveryTruck01,
                title: 'Domicilio',
              ),
              SelectableCard(
                icon: HugeIcons.strokeRoundedPackage,
                title: 'Para llevar',
              ),
            ],
          ),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BadgeContainer(
                title: 'Productos',
                showBadge: true,
                badgeCount: 26,
              ),
              BadgeContainer(
                title: 'Carrito',
                showBadge: true,
                badgeCount: 26,
              ),
              BadgeContainer(
                title: 'Pedidos',
                showBadge: true,
                badgeCount: 26,
              ),
            ],
          ),

          SizedBox(height: 15),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  color: _pageColors[index],
                  child: Center(
                    child: Text(
                      _pageTitles[index],
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                );
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
