// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordena_ya/presentation/pages/NewOrder.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/widgets/TopMenu.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> contentWidgets = [
    NewOrder(product: Product(name: 'Chocolate con leche', quantity: 1, price: 100),),
    Text('Contenido de Pedidos Activos'),
    Text('Contenido de Facturacion'),
    Text('Contenido de Estadisticas'),
    Text('Contenido de Cuadre de Caja'),
  ];


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return Scaffold(
      
      body: SafeArea(
        child: Column(
          children: [
            TopMenu(scrollController: provider.scrollController),
            const Divider(),
            Expanded(
              child: PageView(
                controller: provider.pageController,
                onPageChanged: (i){
                  provider.setIndex(i);
                  provider.scrollToItem(i);
                } ,
                children: contentWidgets
              )
            ),
          ],
        ),
      ),
    );
  }
}
