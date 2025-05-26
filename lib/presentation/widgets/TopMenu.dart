import 'package:flutter/material.dart';

import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/widgets/MenuItem.dart';
import 'package:provider/provider.dart';



class TopMenu extends StatelessWidget {
  final ScrollController scrollController;
  const TopMenu({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child:Row(
        children: List.generate(provider.menuItems.length, (index) {
          final item = provider.menuItems[index];
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