import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/error.dart';
import 'package:ordena_ya/presentation/pages/CartScreen.dart';
import 'package:ordena_ya/presentation/pages/OrdersScreen.dart';
import 'package:ordena_ya/presentation/pages/ProductsScreen.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/providers/tables_provider.dart';
import 'package:ordena_ya/presentation/widgets/AdjustValue.dart';
import 'package:ordena_ya/presentation/widgets/BadgeContainer.dart';
import 'package:ordena_ya/presentation/widgets/selectable_card.dart';
import 'package:ordena_ya/presentation/widgets/SendToKitchenModal.dart';
import 'package:provider/provider.dart';

import '../widgets/CloseBillModal.dart';
import '../widgets/SquareButton.dart';

class NewOrder extends StatelessWidget {
  NewOrder({super.key});

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

  Widget _buildTableSelectionState(BuildContext context) {
    final provider = context.watch<TablesProvider>();

    if (provider.table != null) {
      return Text(
        'Perfecto, estas en la ${provider.table!.tableNumber}',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return Text('No definido', style: TextStyle(fontWeight: FontWeight.bold));
    }
  }

  final List _pages = [ProductsScreen(), CartScreen(), OrdersScreen()];

  final List<Map<String, dynamic>> options = [
    {"icon": HugeIcons.strokeRoundedHome07, "label": 'Mesa'},
    {"icon": HugeIcons.strokeRoundedDeliveryTruck01, "label": 'Domicilio'},
    {"icon": HugeIcons.strokeRoundedPackage, "label": 'Recoger'},
  ];

  final List<String> titles = ['Productos', 'Carrito', 'Pedidos'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final selectedIndex = provider.selectedIndex;
    final peopleIndex = provider.peopleCount;
    final pageController = provider.pageController;
    final enableSendToKitchen = provider.enableSendToKitchen;
    final enableCloseBill = provider.enableCloseBill;

    return Consumer<OrderSetupProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (provider.errorMessage != null &&
              provider.errorMessage!.isNotEmpty) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => AlertDialog(
                    title: const Text(
                      'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    content: Text(
                      extractErrorMessage(provider.errorMessage!),
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          provider.errorMessage = null;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    backgroundColor: AppColors.redPrimary,
                  ),
            );
          }
        });

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Mesa'),
                          _buildTableSelectionState(context),
                        ],
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

                Consumer<OrderSetupProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(titles.length, (index) {
                        return BadgeContainer(
                          title: titles[index],
                          isSelected: provider.currentIndex == index,
                          showBadge:
                              index == 1 && provider.cartItems.isNotEmpty ||
                              index == 2 && provider.orders.isNotEmpty,
                          badgeCount:
                              index == 1
                                  ? provider.cartItems.length
                                  : index == 2
                                  ? provider.orders.length
                                  : 0,
                          onTap: () {
                            provider.goToPage(index);
                          },
                        );
                      }),
                    );
                  },
                ),

                Expanded(
                  child: PageView.builder(
                    controller: pageController,
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
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SquareButton(
                    label: 'Enviar a Cocina',
                    icon: HugeIcons.strokeRoundedSent,
                    isEnabled: enableSendToKitchen,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SendTokitchenModal();
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SquareButton(
                    label: 'Cerrar Cuenta',
                    icon: HugeIcons.strokeRoundedInvoice04,
                    backgroundColor: Colors.green,
                    isEnabled: enableCloseBill,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CloseBillModal();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
