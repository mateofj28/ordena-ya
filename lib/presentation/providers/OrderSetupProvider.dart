import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/order_model.dart';
import 'package:ordena_ya/domain/entities/order.dart';
import 'package:ordena_ya/domain/usecases/create_client.dart';
import 'package:ordena_ya/domain/usecases/get_all_orders.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import 'package:ordena_ya/presentation/pages/OrderDetailScreen.dart';

import '../../domain/usecases/create_order.dart';

class OrderSetupProvider with ChangeNotifier {
  final CreateOrder createOrderUseCase;
  final CreateClient createClientUseCase;
  final GetAllOrders getAllOrdersUseCase;

  OrderSetupProvider({
    required this.createOrderUseCase,
    required this.createClientUseCase,
    required this.getAllOrdersUseCase,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String cedula = '';
  String email = '';

  int _clienteStep = 0;
  int _discountStep = 0;

  // nuevo estado
  // Mapa de los títulos seleccionados
  int _selectedIndex = -1;
  int _currentIndex = 0;
  int _currentMenu = 0;
  int _tableIndex = 1; // M1, M2, ...
  int _peopleCount = 1;

  // State
  final List<Map<String, dynamic>> _cartItems = [];
  int _selectedTabIndex = 0;
  double _discount = 0.0;
  String _selectedTable = 'N/A';
  String _selectedDiscount = 'N/A';
  String _selectedPeople = 'N/A';
  String _selectedClient = '';
  int _deliveryType = 0;
  List<Order> _orders = [];

  bool _isLoadingAllOrders = true;

  // Clientes fijos
  final List<String> clients = [
    'Mateo Florez',
    'Nicolás Gómez',
    'Camila Torres',
    'Andrés Herrera',
    'María López',
  ];

  Map<int, String> deliveryTypeMap = {0: 'Local', 1: 'Recoger', 2: 'Entregar'};
  final Map<String, double> _discountTypeMap = {
    '5%': 0.05,
    '10%': 0.10,
    '20%': 0.20,
    '30%': 0.30,
    '40%': 0.40,
    '50%': 0.50,
    '60%': 0.60,
    '70%': 0.70,
    '80%': 0.80,
    '90%': 0.90,
    '100%': 1.00,
    'N/A': 0.0,
  };

  // Getters
  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedTable => _selectedTable;
  String get selectedDiscount => _selectedDiscount;
  String get selectedPeople => _selectedPeople;
  String get selectedClient => _selectedClient;
  bool get isLoadingAllOrders => _isLoadingAllOrders;
  int get currentMenu => _currentMenu;
  int get tableIndex => _tableIndex;
  int get peopleCount => _peopleCount;
  List<Order> get orders => _orders;
  int get deliveryType => _deliveryType;
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  double get subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) =>
          sum +
          ((item['unitPrice'] as num).toDouble() *
              (item['quantity'] as num).toDouble()),
    );
  }

  double get total {
    const impoconsumoRate = 0.08;
    final subtotalConDescuento = subtotal * (1 - _discount);
    return subtotalConDescuento * (1 + impoconsumoRate);
  }

  int get clienteStep => _clienteStep;
  int get discountStep => _discountStep;
  int get selectedIndex => _selectedIndex;
  int get currentIndex => _currentIndex;


  set clienteStep(int step) {
    _clienteStep = step;
    notifyListeners();
  }

  set discountStep(int step) {
    _discountStep = step;
    notifyListeners();
  }

  void select(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  set selectedDiscount(String value) {
    _selectedDiscount = value;
    _discount = _discountTypeMap[value]!;
    notifyListeners();
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateMenu(int index){
    _currentMenu = index;
    notifyListeners();
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

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void increaseTable() {
    _tableIndex++;
    notifyListeners();
  }

  void decreaseTable() {
    if (_tableIndex > 1) {
      _tableIndex--;
      notifyListeners();
    }
  }

  void increasePeople() {
    _peopleCount++;
    notifyListeners();
  }

  void decreasePeople() {
    if (_peopleCount > 1) {
      _peopleCount--;
      notifyListeners();
    }
  }



  void saveForm(BuildContext context) async {
    formKey.currentState?.save();

    final clientData = {'fullName': name, 'nationalId': cedula, 'email': email};

    try {
      final clientModel = ClientModel.fromJson(clientData);

      final clientEntity = clientModel.toEntity();

      await createClientUseCase.call(clientEntity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Cliente creado exitosamente')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );

      _selectedClient = name; // Asignar el ID del cliente creado
      name = '';
      cedula = '';
      email = '';
      _clienteStep = 2;

      notifyListeners();
    } catch (e) {
      Functions.showErrorSnackBar(context, 'Error al crear el Cliente: $e');
    }
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
    product['total'] = product['unitPrice'] * product['quantity'];
    notifyListeners();
  }

  void decreaseProductQuantity(Map<String, dynamic> product) {
    if ((product['quantity'] ?? 0) > 1) {
      product['quantity']--;
      product['total'] = product['unitPrice'] * product['quantity'];
      notifyListeners();
    }
  }

  void createOrder(BuildContext context) async {
    // Validaciones
    if (_selectedTable == 'N/A' || _selectedPeople == 'N/A') {
      Functions.showErrorSnackBar(
        context,
        'Debes seleccionar una mesa y el número de personas',
      );
      return; // Detiene la ejecución si falla esta validación
    }

    if (_cartItems.isEmpty) {
      Functions.showErrorSnackBar(context, 'El carrito está vacío');
      return;
    }

    try {
      // Si pasa todas las validaciones, se construye la orden
      final orderData = {
        'orderNumber': 'ORD123',
        'assignedTable': _selectedTable,
        'numberOfPeople': int.parse(_selectedPeople),
        'clientId': _selectedClient == '' ? 'Indefinido' : _selectedClient,
        'deliveryType': deliveryTypeMap[_deliveryType],
        'orderedProducts': _cartItems,
        'discountApplied': _discount,
        'paymentMethod': 'efectivo',
        'orderStatus': 'pending',
        'totalValue': total,
        'orderDate': DateTime.now().toIso8601String(),
        'statusUpdatedAt': DateTime.now().toIso8601String(),
      };

      final orderModel = OrderModel.fromJson(orderData);

      final clientEntity = orderModel.toEntity();

      await createOrderUseCase.call(clientEntity);

      // Limpiar carrito luego de crear la orden
      _selectedTable = 'N/A';
      _selectedDiscount = 'N/A';
      _selectedPeople = 'N/A';
      _selectedClient = '';
      _deliveryType = 0;
      _discountStep = 0;
      _cartItems.clear();
      notifyListeners();

      // Puedes mostrar una notificación de éxito si deseas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Orden creada exitosamente')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e, stacktrace) {
      // print('❌ Error en OrderedProductModel.fromJson: $e');
      // print(stacktrace);
      Functions.showErrorSnackBar(context, 'Error al crear la orden: $e');
    }
  }

  getAllOrders(BuildContext context) async {
    try {
      _isLoadingAllOrders = true;
      notifyListeners();

      _orders = await getAllOrdersUseCase.call();
      _isLoadingAllOrders = false;
      notifyListeners();
    } catch (e) {
      Functions.showErrorSnackBar(context, 'Error al traer las ordenes: $e');
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
