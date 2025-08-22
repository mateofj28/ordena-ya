// main.dart
import 'package:flutter/material.dart';

import 'package:ordena_ya/presentation/pages/NewOrder.dart';
import 'package:ordena_ya/presentation/pages/ViewAllOrders.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/widgets/TopMenu.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> contentWidgets = [
    NewOrder(
      product: Product(name: 'Chocolate con leche', quantity: 1, price: 100),
    ),
    ViewAllOrders(),
    Text('Contenido de Facturacion'),
    Text('Contenido de Estadisticas'),
    Text('Contenido de Cuadre de Caja'),
  ];

  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderSetupProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<MenuProvider>(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TopMenu(views: provider.views),
                  const Divider(),
                  Expanded(
                    child: PageView(
                      controller: provider.pageController,
                      onPageChanged: (i) {

                        if (i == 1){
                          // if (orderProvider.orders.isEmpty) {
                          // }  
                          orderProvider.getAllOrders();
                        }

                        provider.setIndex(i);
                        provider.scrollToItem(i);
                      },
                      children: contentWidgets,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
