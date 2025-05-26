import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MenuProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<MenuItemData> menuItems = [
    MenuItemData(HugeIcons.strokeRoundedAddToList, 'Nuevo Pedido'),
    MenuItemData(HugeIcons.strokeRoundedFolderLibrary, 'Pedidos Activos'),
    MenuItemData(HugeIcons.strokeRoundedReceiptDollar, 'Facturación'),
    MenuItemData(HugeIcons.strokeRoundedPieChart02, 'Estadísticas'),
    MenuItemData(HugeIcons.strokeRoundedCashier, 'Cuadre de Caja'),
  ];

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setIndex(index);
  }

  void scrollToItem(int index) {
    // Ajusta este valor si los ítems tienen diferente ancho
    double itemWidth = 80.0;
    double offset = (itemWidth + 24) * index - 20;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String label;
  MenuItemData(this.icon, this.label);
}
