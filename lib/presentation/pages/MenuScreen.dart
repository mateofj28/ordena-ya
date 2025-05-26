import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/widgets/MenuItemCard.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text("Menú", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: ConsumerTabBar(),
          ),
        ),
        body: const TabBarView(
          children: [
            Entradas(),
            PlatosFuertes(),
            Tacos(),
            Bebidas(),
            Postres(),
          ],
        ),
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
          borderSide: BorderSide(width: 3.0, color: AppColors.primaryButtonText),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        ), // necesitarías definirla,
        indicatorPadding: EdgeInsets.all(10),
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelColor: AppColors.primaryButtonText,
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

class Entradas extends StatelessWidget {
  const Entradas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        children: const [
          MenuItemCard(
            name: "Nachos con queso",
            price: "\$12.000",
            description: "Totopos crujientes bañados en queso cheddar.",
            image: Icon(Icons.local_dining),
          ),
          MenuItemCard(
            name: "Ceviche de camarón",
            price: "\$15.500",
            description: "Camarones frescos marinados en limón y especias.",
            image: Icon(Icons.set_meal),
          ),
          MenuItemCard(
            name: "Tartar de salmón",
            price: "\$17.000",
            description: "Salmón fresco, aguacate, salsa de soja y sésamo.",
            image: Icon(Icons.ramen_dining),
          ),
        ],
      ),
    );
  }
}

class PlatosFuertes extends StatelessWidget {
  const PlatosFuertes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        children: const [
          MenuItemCard(
            name: "Lomo en salsa de champiñones",
            price: "\$25.000",
            description:
                "Tierna carne de res acompañada de una cremosa salsa de champiñones.",
            image: Icon(Icons.dinner_dining),
          ),
          MenuItemCard(
            name: "Pollo a la parrilla",
            price: "\$22.000",
            description:
                "Pechuga de pollo marinada y asada con vegetales al vapor.",
            image: Icon(Icons.local_fire_department),
          ),
          MenuItemCard(
            name: "Pasta carbonara",
            price: "\$20.000",
            description:
                "Spaghetti con salsa cremosa, tocineta y queso parmesano.",
            image: Icon(Icons.ramen_dining),
          ),
        ],
      ),
    );
  }
}

class Tacos extends StatelessWidget {
  const Tacos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        children: const [
          MenuItemCard(
            name: "Taco al pastor",
            price: "\$8.500",
            description: "Cerdo adobado con piña, cebolla y cilantro fresco.",
            image: Icon(Icons.fastfood),
          ),
          MenuItemCard(
            name: "Taco de carne asada",
            price: "\$9.000",
            description: "Carne de res marinada servida con guacamole y cebolla.",
            image: Icon(Icons.lunch_dining),
          ),
          MenuItemCard(
            name: "Taco vegetariano",
            price: "\$7.500",
            description: "Tortilla rellena de champiñones, pimientos y queso.",
            image: Icon(Icons.eco),
          ),
        ],
      ),
    );
  }
}

class Bebidas extends StatelessWidget {
  const Bebidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        children: const [
          MenuItemCard(
            name: "Jugo natural",
            price: "\$4.000",
            description: "Jugo de naranja, mango o fresa preparado al momento.",
            image: Icon(Icons.local_drink),
          ),
          MenuItemCard(
            name: "Limonada de coco",
            price: "\$5.500",
            description: "Refrescante mezcla de limón, leche de coco y hielo.",
            image: Icon(Icons.emoji_food_beverage),
          ),
          MenuItemCard(
            name: "Cerveza artesanal",
            price: "\$7.000",
            description: "Variedad de cervezas locales: rubia, roja o negra.",
            image: Icon(Icons.sports_bar),
          ),
        ],
      ),
    );
  }
}

class Postres extends StatelessWidget {
  const Postres({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        children: const [
          MenuItemCard(
            name: "Tarta de queso",
            price: "\$6.500",
            description:
                "Suave tarta de queso con base de galleta y frutos rojos.",
            image: Icon(Icons.cake),
          ),
          MenuItemCard(
            name: "Brownie con helado",
            price: "\$7.000",
            description:
                "Brownie de chocolate caliente con bola de helado de vainilla.",
            image: Icon(Icons.icecream),
          ),
          MenuItemCard(
            name: "Flan de caramelo",
            price: "\$5.500",
            description: "Clásico flan casero con caramelo líquido.",
            image: Icon(Icons.rice_bowl),
          ),
        ],
      ),
    );
  }
}
