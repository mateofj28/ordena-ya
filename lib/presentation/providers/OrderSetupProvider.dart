import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import 'package:ordena_ya/presentation/pages/OrderDetailScreen.dart';

import '../../domain/usecases/create_order.dart';

class OrderSetupProvider with ChangeNotifier {
  final CreateOrder createOrderUseCase;

  OrderSetupProvider({required this.createOrderUseCase});

  // State
  final List<Map<String, dynamic>> _cartItems = [];
  int _selectedTabIndex = 0;
  String _selectedTable = 'N/A';
  String _selectedPeople = 'N/A';
  String _selectedClient = '';
  int _deliveryType = 0;

  // Clientes fijos
  final List<String> clients = [
    'Mateo Florez',
    'Nicolás Gómez',
    'Camila Torres',
    'Andrés Herrera',
    'María López',
  ];

  // Getters
  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedTable => _selectedTable;
  String get selectedPeople => _selectedPeople;
  String get selectedClient => _selectedClient;
  int get deliveryType => _deliveryType;
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  double get subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) =>
          sum +
          ((item['price'] as num).toDouble() *
              (item['quantity'] as num).toDouble()),
    );
  }

  double get total {
    const impoconsumoRate = 0.08;
    return subtotal * (1 + impoconsumoRate);
  }

  // Setters
  void updateSelectedTable(String table) {
    _selectedTable = table;
    notifyListeners();
  }

  void updateSelectedPeople(String people) {
    _selectedPeople = people;
    notifyListeners();
  }

  void updateSelectedClient(String client) {
    _selectedClient = client;
    notifyListeners();
  }

  void updateSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void updateDeliveryType(int type) {
    _deliveryType = type;
    notifyListeners();
  }

  // a futuro cambiar este por buscar por id
  void addProductToCart(Map<String, dynamic> product) {
    final existingProductIndex = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingProductIndex != -1) {
      // Ya existe en el carrito, incrementamos la cantidad
      _cartItems[existingProductIndex]['quantity'] += 1;
    } else {
      // No existe, lo agregamos con cantidad 1
      final newProduct = Map<String, dynamic>.from(product);
      newProduct['quantity'] = 1;
      _cartItems.add(newProduct);
    }

    notifyListeners();
  }

  void removeProductFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void increaseProductQuantity(Map<String, dynamic> product) {
    product['quantity'] = (product['quantity'] ?? 0) + 1;
    product['total'] = product['price'] * product['quantity'];
    notifyListeners();
  }

  void decreaseProductQuantity(Map<String, dynamic> product) {
    if ((product['quantity'] ?? 0) > 1) {
      product['quantity']--;
      product['total'] = product['price'] * product['quantity'];
      notifyListeners();
    }
  }

  createOrder() async {
    if (_cartItems.isEmpty) {
      throw Exception('El carrito está vacío');
    }

    final orderData = {
      'table': _selectedTable,
      'people': _selectedPeople,
      'client': _selectedClient,
      'deliveryType': _deliveryType,
      'items': _cartItems,
      'status': 'pending',
    };

    try {
      print(orderData);
      // Clear cart after successful order creation
      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('Error al crear la orden: $e');
    }
  }

  // UI utils
  bool isTableSelected(String table) => _selectedTable == table;
  bool isTabSelected(int index) => _selectedTabIndex == index;

  // Navigation
  void navigateToMenuScreen(BuildContext context) {
    _navigateWithSlideTransition(context, MenuScreen());
  }

  void navigateToOrderDetailScreen(BuildContext context) {
    _navigateWithSlideTransition(context, OrderDetailScreen());
  }

  void _navigateWithSlideTransition(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;

          final tween = Tween(
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
