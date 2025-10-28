import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/providers/menu_provider.dart';
import 'package:ordena_ya/presentation/widgets/MenuItem.dart';
import 'package:provider/provider.dart';



class TopMenu extends StatelessWidget {
  final List<MenuItemData> views;

  const TopMenu({
    super.key,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return SingleChildScrollView(
      controller: provider.scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: Row(
        children: List.generate(views.length, (index) {
          final item = views[index];
          return MenuItem(
            icon: item.icon,
            label: item.label,
            index: index,
            selectedIndex: provider.currentIndex,
            onTap: () {
              provider.animateToPage(index);
              provider.scrollToItem(index);
            },
          );
        }),
      ),
    );
  }
}
