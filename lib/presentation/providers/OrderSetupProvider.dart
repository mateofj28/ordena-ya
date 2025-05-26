import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import 'package:ordena_ya/presentation/pages/NewOrder.dart';
import 'package:ordena_ya/presentation/pages/OrderDetailScreen.dart';

class OrderSetupProvider with ChangeNotifier {
  List _carts = [];
  int _selectedOption = 0;
  String _selectedTable = 'Seleccionar opción';
  String _selectedPeople = 'Seleccionar opción';
  String selectedClient = '';
  final List<String> clients = [
    'Mateo Florez',
    'Nicolás Gómez',
    'Camila Torres',
    'Andrés Herrera',
    'María López',
  ];

  List<Product> products = [
    Product(name: 'Chocolate con leche', quantity: 1, price: 100),
    Product(name: 'Pan con queso y arequipe', quantity: 4, price: 100),
    Product(name: 'Sándwich de pollo', quantity: 3, price: 400),
  ];

  String get selectedTable => _selectedTable;
  String get selectedPeople => _selectedPeople;
  int get selectedOption => _selectedOption;
  List get carts => _carts;

  void setSelectedTable(String value) {
    _selectedTable = value;
    notifyListeners();
  }

  void setSelectedPeople(String value) {
    _selectedPeople = value;
    notifyListeners();
  }

  void setSelectedClient(String client) {
    selectedClient = client;
    notifyListeners();
  }

  void increment(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decrement(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
      notifyListeners();
    }
  }

  void remove(Product product) {
    products.remove(product);
    notifyListeners();
  }

  void setSelectedOption(int option) {
    _selectedOption = option;
    notifyListeners();
  }

  bool isSelected(String table) => _selectedTable == table;
  bool isSelectedOption(String option) => _selectedOption == option;

  void addToCart(dynamic product) {
    _carts.add(product);
    print(_carts.length);
  }

  removeFromCart(int index) {
    _carts.removeAt(index);
  }

  void handledAddProduct(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => MenuScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0); // desde abajo
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void handledViewDetails(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => OrderDetailScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0); // desde abajo
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
