import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/widgets/TopMenu.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final List<Widget> contentWidgets = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<MenuProvider>(context);
          final orderProvider = Provider.of<OrderSetupProvider>(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TopMenu(views: provider.menus),
                  const Divider(),
                  Expanded(
                    child: PageView(
                      controller: provider.pageController,
                      onPageChanged: (i) {
                        provider.setIndex(i);
                        provider.scrollToItem(i);
                      },
                      children: contentWidgets,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: const EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  if (orderProvider.cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No hay productos en el carrito"),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                label: Text('${orderProvider.cartItems.length}'),
                icon: const Icon(Icons.shopping_cart),
                backgroundColor: AppColors.redPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ConsumerTabBar extends StatelessWidget {
  const ConsumerTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TabBar(
        isScrollable: true,
        controller: controller,

        tabs: const [
          _CustomTab(icon: Icons.fastfood, label: "Entradas", index: 0),
          _CustomTab(icon: Icons.restaurant, label: "Platos fuertes", index: 1),
          _CustomTab(icon: Icons.local_dining, label: "Tacos", index: 2),
          _CustomTab(icon: Icons.local_drink, label: "Bebidas", index: 3),
          _CustomTab(icon: Icons.cake, label: "Postres", index: 4),
        ],
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: AppColors.redPrimary,
          ),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        ), // necesitarías definirla,
        indicatorPadding: EdgeInsets.all(10),
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelColor: AppColors.redPrimary,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}

class _CustomTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const _CustomTab({
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    final isSelected = controller.index == index;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
