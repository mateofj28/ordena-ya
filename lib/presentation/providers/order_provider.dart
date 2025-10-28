import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/domain/dto/order_item.dart';
import 'package:ordena_ya/domain/dto/register_order_req.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import '../../domain/usecase/add_item_to_order.dart';
import '../../domain/usecase/create_order.dart';

enum OrderStatus { initial, loading, success, error }

class OrderSetupProvider with ChangeNotifier {
  final CreateOrder createOrderUseCase;
  final AddItemToOrderUseCase addItemToOrderUseCase;
  final GetOrdersUseCase getAllOrdersUseCase;

  OrderSetupProvider({
    required this.createOrderUseCase,
    required this.addItemToOrderUseCase,
    required this.getAllOrdersUseCase,
  });

  OrderStatus status = OrderStatus.initial;
  String? _errorMessage = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String cedula = '';
  String email = '';
  Order? _currentOrder;
  int _tableId = 0;
  String _clientId = '';

  int _clienteStep = 0;
  int _discountStep = 0;

  bool _enableSendToKitchen = false;
  bool _enableCloseBill = false;

  int _selectedIndex = 0;
  int _currentIndex = 0;
  int _currentMenu = 0;
  int _tableIndex = 1;
  int _peopleCount = 1;
  int _productCount = 1;
  List<Order> _orders = [];
  final PageController _pageController = PageController();

  final List<Product> _cartItems = [];

  final _products = [
    {
      'name': 'Mesa 1',
      'people': '2 Personas',
      'date': '21/06/2025',
      'time': '7:34 pm',
      'total': 18500,
    },
    {
      'name': 'Mesa 2',
      'people': '3 Personas',
      'date': '21/06/2025',
      'time': '8:15 pm',
      'total': 24500,
    },
    {
      'name': 'Mesa 3',
      'people': '4 Personas',
      'date': '21/06/2025',
      'time': '8:50 pm',
      'total': 35000,
    },
    {
      'name': 'Mesa 4',
      'people': '5 Personas',
      'date': '21/06/2025',
      'time': '9:10 pm',
      'total': 42500,
    },
    {
      'name': 'Mesa 5',
      'people': '6 Personas',
      'date': '21/06/2025',
      'time': '9:35 pm',
      'total': 58000,
    },
  ];

  int _selectedTabIndex = 0;
  String _selectedTable = 'N/A';
  String _selectedDiscount = 'N/A';
  final String _selectedPeople = 'N/A';
  String _selectedClient = '';
  int _deliveryType = 0;

  bool _isLoadingAllOrders = true;

  // Clientes fijos
  final List<String> clients = [
    'Mateo Florez',
    'Nicolás Gómez',
    'Camila Torres',
    'Andrés Herrera',
    'María López',
  ];

  Map<int, String> deliveryTypeMap = {
    0: 'dine_in',
    1: 'delivery',
    2: 'take_out',
  };

  // Getters
  List<Product> get cartItems => _cartItems;
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedTable => _selectedTable;
  String? get errorMessage => _errorMessage;
  String get selectedDiscount => _selectedDiscount;
  String get selectedPeople => _selectedPeople;
  String get selectedClient => _selectedClient;
  bool get isLoadingAllOrders => _isLoadingAllOrders;
  int get currentMenu => _currentMenu;
  int get tableIndex => _tableIndex;
  bool get enableSendToKitchen => _enableSendToKitchen;
  bool get enableCloseBill => _enableCloseBill;
  int get peopleCount => _peopleCount;
  int get productCount => _productCount;
  List<Order> get orders => _orders;
  List get products => _products;
  PageController get pageController => _pageController;
  int get deliveryType => _deliveryType;

  double get subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );
  }

  double get tax => subtotal * 0.08;

  double get total => subtotal + tax;

  int get clienteStep => _clienteStep;
  int get discountStep => _discountStep;
  int get selectedIndex => _selectedIndex;
  int get currentIndex => _currentIndex;

  set clienteStep(int step) {
    _clienteStep = step;
    notifyListeners();
  }

  set enableSendToKitchen(bool value) {
    _enableSendToKitchen = value;
    notifyListeners();
  }

  set enableCloseBill(bool value) {
    _enableCloseBill = value;
    notifyListeners();
  }

  set discountStep(int step) {
    _discountStep = step;
    notifyListeners();
  }

  set tableId(int id) {
    _tableId = id;
    notifyListeners();
  }

  set clientId(String value) {
    _clientId = value;
    notifyListeners();
  }

  void select(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  set selectedDiscount(String value) {
    _selectedDiscount = value;
    notifyListeners();
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateMenu(int index) {
    _currentMenu = index;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Setters
  void updateSelectedTable(String table) {
    _selectedTable = table;
    notifyListeners();
  }

  set productCount(int index) {
    _productCount = index;
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
    updateLastOrderWithTablesOrPeople();
    notifyListeners();
  }

  void decreaseTable() {
    if (_tableIndex > 1) {
      _tableIndex--;
      updateLastOrderWithTablesOrPeople();
      notifyListeners();
    }
  }

  void increaseProduct() {
    _productCount++;
    notifyListeners();
  }

  void decreaseProduct() {
    if (_productCount > 1) {
      _productCount--;
      notifyListeners();
    }
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void increasePeople() {
    if (_selectedIndex == 1 || _selectedIndex == 2) return;
    _peopleCount++;

    updateLastOrderWithTablesOrPeople();
    notifyListeners();
  }

  void decreasePeople() {
    if (_selectedIndex == 1 || _selectedIndex == 2) return;
    if (_peopleCount > 1) {
      _peopleCount--;
      updateLastOrderWithTablesOrPeople();
      notifyListeners();
    }
  }

  String getConsumptionType(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'mesa';
      case 1:
        return 'domicilio';
      case 2:
        return 'recoger';
      default:
        return 'mesa'; // valor por defecto
    }
  }

  Future<void> goToPage(int index) async {
    _pageController.jumpToPage(index);
  }

  void saveForm(BuildContext context) async {
    formKey.currentState?.save();

    final clientData = {'fullName': name, 'nationalId': cedula, 'email': email};

    try {
      final clientModel = ClientModel.fromJson(clientData);

      final clientEntity = clientModel.toEntity();
      Logger.info('Cliente creado: ${clientEntity.fullName}');

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

  bool hasPendingProducts() {
    return _cartItems.isNotEmpty;
  }

  CreateOrderReq buildOrderObject() {
    String consumptionType = getConsumptionType(_selectedIndex);
    String? clientIdValue = _selectedIndex == 1 ? _clientId : null;
    int peopleCountValue = _selectedIndex == 0 ? _peopleCount : 1;

    CreateOrderReq order = CreateOrderReq(
      tenantId: 1,
      tableId: _tableId,
      peopleCount: peopleCountValue,
      consumptionType: consumptionType,
      clientId: clientIdValue,
    );
    return order;
  }

  String? _validateOrderRequirements() {
    switch (_selectedIndex) {
      case 0: // Mesa
        if (_tableId == 0) {
          return "Debes seleccionar una mesa antes de crear tu orden";
        }
        break;
      case 1: // Domicilio
        if (_clientId.isEmpty) {
          return "Debe seleccionar un cliente antes de crear la orden";
        }
        break;
      case 2: // Recoger
        // No necesita validación adicional
        break;
      default:
        return "Tipo de consumo no válido.";
    }
    return null; // Sin errores
  }

  void addProductToCart(Product product) async {
    // Validar requisitos antes de proceder
    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      errorMessage = validationError;
      return; // Detener ejecución si hay error
    }

    final index = _cartItems.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      int currentQuantity = _cartItems[index].quantity;
      int newQuantity = product.quantity;
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: currentQuantity + newQuantity,
      );
      notifyListeners();
    } else {
      if (_currentOrder != null) {
        _cartItems.add(product);
        await addProductToOrder(
          _currentOrder!.orderId!,
          OrderItem.fromProduct(product),
        );
      } else {
        _cartItems.add(product);
        CreateOrderReq newOrder = buildOrderObject();
        createOrder(newOrder, product);
      }
    }

    enableSendToKitchen = true;
    _productCount = 1;
    notifyListeners();
  }

  void removeProductFromCart(Product product) {
    _cartItems.removeWhere((item) => item.id == product.id);
    enableSendToKitchen = hasPendingProducts();
    notifyListeners();
  }

  void updateLastOrderWithTablesOrPeople() {
    if (_orders.isEmpty) return;
    Logger.info('Actualizando mesa: $_tableIndex, personas: $_peopleCount');
  }

  void increaseProductQuantity(Product product) {
    final index = _cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (product.quantity < 99) ? product.quantity + 1 : 99,
      );
    }
    enableSendToKitchen = true;
    notifyListeners();
  }

  void decreaseProductQuantity(Product product) {
    final index = _cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: (product.quantity > 1) ? product.quantity - 1 : 1,
      );
    }
    enableSendToKitchen = hasPendingProducts();
    notifyListeners();
  }

  Future<void> createOrder(CreateOrderReq order, Product product) async {
    final result = await createOrderUseCase.call(order);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        Logger.error('Error creando orden: ${failure.message}');
      },
      (createdOrder) async {
        Logger.info('Orden creada exitosamente');
        _currentOrder = createdOrder;
        await addProductToOrder(
          createdOrder.orderId!,
          OrderItem.fromProduct(product),
        );
        errorMessage = '';
      },
    );
    notifyListeners();
  }

  Future<void> addProductToOrder(String orderId, OrderItem item) async {
    final result = await addItemToOrderUseCase.call(orderId, item);

    result.fold(
      (failure) async {
        Logger.error('Error agregando producto: ${failure.message}');
        await getAllOrders();
        errorMessage = failure.message;
      },
      (_) {
        Logger.info('Producto agregado exitosamente');
        errorMessage = '';
      },
    );

    notifyListeners();
  }

  Future<void> getAllOrders() async {
    status = OrderStatus.loading;
    notifyListeners();

    var result = await getAllOrdersUseCase.call();

    result.fold(
      (failure) {
        status = OrderStatus.error;
        errorMessage = failure.message;
        Logger.error('Error obteniendo órdenes: ${failure.message}');
        notifyListeners();
      },
      (orders) {
        _orders = orders;
        status = OrderStatus.success;
        errorMessage = '';
        _isLoadingAllOrders = false;
        Logger.info('Órdenes obtenidas exitosamente: ${orders.length}');
        notifyListeners();
      },
    );
  }

  // Navigation
  void navigateToMenuScreen(BuildContext context) {
    _navigateWithSlideTransition(context, MenuScreen());
  }

  void navigateToOrderDetailScreen(BuildContext context) {}

  void _navigateWithSlideTransition(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;

          final tween = Tween<Offset>(
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
