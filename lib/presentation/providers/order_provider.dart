import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';
import 'package:ordena_ya/domain/dto/order_item.dart';
import 'package:ordena_ya/domain/dto/register_order_req.dart';
import 'package:ordena_ya/domain/entity/cart_item.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders_new.dart';
import 'package:ordena_ya/domain/usecase/create_order_new.dart';
import 'package:ordena_ya/domain/usecase/update_order.dart';
import 'package:ordena_ya/domain/usecase/close_order.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/presentation/pages/MenuScreen.dart';
import '../../domain/usecase/add_item_to_order.dart';
import '../../domain/usecase/create_order.dart';

enum OrderStatus { initial, loading, success, error }

class OrderSetupProvider with ChangeNotifier {
  final CreateOrder createOrderUseCase;
  final AddItemToOrderUseCase addItemToOrderUseCase;
  final GetOrdersUseCase getAllOrdersUseCase;
  final GetAllOrdersNewUseCase getAllOrdersNewUseCase;
  final CreateOrderNewUseCase createOrderNewUseCase;
  final UpdateOrderUseCase updateOrderUseCase;
  final CloseOrderUseCase closeOrderUseCase;

  OrderSetupProvider({
    required this.createOrderUseCase,
    required this.addItemToOrderUseCase,
    required this.getAllOrdersUseCase,
    required this.getAllOrdersNewUseCase,
    required this.createOrderNewUseCase,
    required this.updateOrderUseCase,
    required this.closeOrderUseCase,
  });

  OrderStatus status = OrderStatus.initial;
  String? _errorMessage = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String cedula = '';
  String email = '';

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
  List<OrderResponseEntity> _newOrders = [];
  final PageController _pageController = PageController();

  final List<Product> _cartItems = [];
  final List<CartItem> _newCartItems = []; // Nuevo carrito usando CartItem



  int _selectedTabIndex = 0;
  String _selectedTable = 'N/A';
  String _selectedDiscount = 'N/A';
  final String _selectedPeople = 'N/A';
  String _selectedClient = '';
  int _deliveryType = 0;

  bool _isLoadingAllOrders = true;



  Map<int, String> deliveryTypeMap = {
    0: 'dine_in',
    1: 'delivery',
    2: 'take_out',
  };

  // Getters
  List<Product> get cartItems => _cartItems;
  List<CartItem> get newCartItems => List.unmodifiable(_newCartItems);
  int get selectedTabIndex => _selectedTabIndex;
  String get selectedTable => _selectedTable;
  String? get errorMessage => _errorMessage;
  String get selectedDiscount => _selectedDiscount;
  String get selectedPeople => _selectedPeople;
  String get selectedClient => _selectedClient;
  String get clientId => _clientId;
  bool get isLoadingAllOrders => _isLoadingAllOrders;
  
  // Getters para el nuevo carrito
  bool get hasCartItems => _newCartItems.isNotEmpty;
  int get totalCartItems => _newCartItems.length; // Cantidad de productos únicos, no total de cantidades
  double get cartSubtotal => _newCartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get cartTax => cartSubtotal * 0.08;
  double get cartTotal => cartSubtotal + cartTax;
  
  // Estado de la orden actual
  OrderResponseEntity? _currentOrderEntity;
  OrderResponseEntity? get currentOrderEntity => _currentOrderEntity;



  // Cargar orden actual desde las órdenes existentes
  void loadCurrentOrderFromExisting() {
    Logger.info('loadCurrentOrderFromExisting called - Orders available: ${_newOrders.length}');
    
    if (_newOrders.isNotEmpty) {
      Logger.info('Current config - tableIndex: $_tableIndex, orderType: ${_getOrderTypeString()}');
      
      // Por ahora, tomar la primera orden disponible para debuggear
      final matchingOrder = _newOrders.first;
      
      Logger.info('Selected order - ID: ${matchingOrder.id}, Mesa: ${matchingOrder.mesa}, Tipo: ${matchingOrder.tipoPedido}, Estado: ${matchingOrder.estadoGeneral}');
      
      _currentOrderEntity = matchingOrder;
      Logger.info('_currentOrderEntity assigned - ID: ${_currentOrderEntity?.id}');
      
      // Actualizar valores actuales con los de la orden
      _tableIndex = matchingOrder.mesa;
      _peopleCount = matchingOrder.cantidadPersonas;
      _selectedIndex = _getIndexFromOrderType(matchingOrder.tipoPedido);
      
      Logger.info('Loaded order values - Table: $_tableIndex, People: $_peopleCount, Type: $_selectedIndex');
      
      // Cargar los productos de la orden al carrito
      _loadCartFromOrder(matchingOrder);
      
      // Verificar cambios (debería estar deshabilitado inicialmente)
      _checkForChanges();
    } else {
      Logger.info('No orders available to load');
    }
  }

  // Cargar carrito desde una orden existente
  void _loadCartFromOrder(OrderResponseEntity order) {
    _newCartItems.clear();
    
    for (var product in order.productosSolicitados) {
      final cartItem = CartItem(
        productId: product.productId,
        productName: product.nombreProducto,
        price: product.price,
        quantity: product.cantidadSolicitada,
        message: product.mensaje,
      );
      _newCartItems.add(cartItem);
    }
    
    enableSendToKitchen = _newCartItems.isNotEmpty;
    Logger.info('Loaded ${_newCartItems.length} items to cart from order');
  }

  // Obtener string del tipo de orden
  String _getOrderTypeString() {
    switch (_selectedIndex) {
      case 0: return 'table';
      case 1: return 'delivery';
      case 2: return 'takeout';
      default: return 'table';
    }
  }

  // Obtener índice desde string del tipo de orden
  int _getIndexFromOrderType(String orderType) {
    switch (orderType) {
      case 'table': return 0;
      case 'delivery': return 1;
      case 'takeout': return 2;
      default: return 0;
    }
  }

  // Métodos para manejar items del carrito (solo cambios locales)
  void increaseCartItemQuantity(int index) {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      _newCartItems[index] = item.copyWith(quantity: item.quantity + 1);
      
      // Verificar cambios respecto a la orden actual
      _checkForChanges();
      notifyListeners();
    }
  }

  void decreaseCartItemQuantity(int index) {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      if (item.quantity > 1) {
        _newCartItems[index] = item.copyWith(quantity: item.quantity - 1);
        
        // Verificar cambios respecto a la orden actual
        _checkForChanges();
        notifyListeners();
      }
    }
  }

  void updateCartItemMessage(int index, String message) {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      _newCartItems[index] = item.copyWith(message: message);
      
      // Verificar cambios respecto a la orden actual
      _checkForChanges();
      notifyListeners();
    }
  }

  Future<void> removeCartItemAt(int index) async {
    if (index >= 0 && index < _newCartItems.length) {
      final removedItem = _newCartItems[index];
      _newCartItems.removeAt(index);
      
      Logger.info('Product removed from cart: ${removedItem.productName}');
      
      // Si hay orden actual, actualizar en el backend
      if (_currentOrderEntity != null) {
        await _updateExistingOrder();
        
        // Si hubo error, revertir el cambio
        if (status == OrderStatus.error) {
          _newCartItems.insert(index, removedItem);
          Logger.error('Failed to remove product from order, reverted local change');
        }
      }
      
      // Verificar cambios respecto a la orden actual
      _checkForChanges();
      notifyListeners();
    }
  }
  
  // TODO: Implement proper client management
  List<String> get clients => ['Cliente 1', 'Cliente 2', 'Cliente 3'];
  int get currentMenu => _currentMenu;
  int get tableIndex => _tableIndex;
  bool get enableSendToKitchen => _enableSendToKitchen;
  bool get enableCloseBill => _enableCloseBill;
  int get peopleCount => _peopleCount;
  int get productCount => _productCount;
  List<Order> get orders => _orders;
  List<OrderResponseEntity> get newOrders => _newOrders;

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
    _tableIndex = id; // Sincronizar ambas variables
    _checkForChanges(); // Verificar si hay cambios
    Logger.info('Table selected: $_tableIndex');
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
    _tableId = _tableIndex; // Sincronizar
    updateLastOrderWithTablesOrPeople();
    _checkForChanges();
    notifyListeners();
  }

  void decreaseTable() {
    if (_tableIndex > 1) {
      _tableIndex--;
      _tableId = _tableIndex; // Sincronizar
      updateLastOrderWithTablesOrPeople();
      _checkForChanges();
      notifyListeners();
    }
  }

  void increasePeople() {
    _peopleCount++;
    updateLastOrderWithTablesOrPeople();
    _checkForChanges();
    notifyListeners();
  }

  void decreasePeople() {
    if (_peopleCount > 1) {
      _peopleCount--;
      updateLastOrderWithTablesOrPeople();
      _checkForChanges();
      notifyListeners();
    }
  }

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    _checkForChanges();
    Logger.info('Delivery type changed to: $index');
    notifyListeners();
  }

  // Verificar si hay cambios respecto al estado ACTUAL de la orden
  void _checkForChanges() {
    if (_currentOrderEntity != null) {
      // Comparar con el estado ACTUAL de la orden (no el original)
      bool hasTableChanges = _tableIndex != _currentOrderEntity!.mesa;
      bool hasPeopleChanges = _peopleCount != _currentOrderEntity!.cantidadPersonas;
      bool hasTypeChanges = _selectedIndex != _getIndexFromOrderType(_currentOrderEntity!.tipoPedido);
      bool hasCartChanges = _hasCartChanges();
      
      bool hasChanges = hasTableChanges || hasPeopleChanges || hasTypeChanges || hasCartChanges;
      
      enableSendToKitchen = hasChanges;
      Logger.info('Changes detected - Table: $_tableIndex vs ${_currentOrderEntity!.mesa}, People: $_peopleCount vs ${_currentOrderEntity!.cantidadPersonas}, Type: $_selectedIndex vs ${_getIndexFromOrderType(_currentOrderEntity!.tipoPedido)}, Cart: $hasCartChanges, Enable: $enableSendToKitchen');
    } else {
      // Si no hay orden actual, habilitar si hay productos en el carrito
      enableSendToKitchen = _newCartItems.isNotEmpty;
    }
  }

  // Verificar si hay cambios en el carrito (cantidades y observaciones)
  bool _hasCartChanges() {
    if (_currentOrderEntity == null) return _newCartItems.isNotEmpty;
    
    // Comparar productos del carrito con los de la orden actual
    if (_newCartItems.length != _currentOrderEntity!.productosSolicitados.length) {
      return true;
    }
    
    for (int i = 0; i < _newCartItems.length; i++) {
      final cartItem = _newCartItems[i];
      
      // Buscar el producto correspondiente en la orden
      final orderProduct = _currentOrderEntity!.productosSolicitados.firstWhere(
        (p) => p.productId == cartItem.productId,
        orElse: () => throw Exception('Product not found'),
      );
      
      // Comparar cantidad y mensaje
      if (cartItem.quantity != orderProduct.cantidadSolicitada ||
          cartItem.message != orderProduct.mensaje) {
        return true;
      }
    }
    
    return false;
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

  // Método para sincronizar configuración con CartProvider
  void syncWithCartProvider(dynamic cartProvider) {
    // Mapear tipos de orden
    String orderType;
    switch (_selectedIndex) {
      case 0:
        orderType = 'table';
        break;
      case 1:
        orderType = 'delivery';
        break;
      case 2:
        orderType = 'takeout';
        break;
      default:
        orderType = 'table';
    }

    cartProvider.setOrderType(orderType);
    cartProvider.setTableNumber(_tableIndex);
    cartProvider.setPeopleCount(_peopleCount);
    cartProvider.setClientId(_clientId);
  }

  // Métodos para el nuevo carrito
  Future<void> addProductToNewCart(Product product, {String message = ''}) async {
    // Validar requisitos antes de proceder
    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return;
    }

    // Crear el item del carrito
    final cartItem = CartItem(
      productId: product.id,
      productName: product.name,
      price: product.unitPrice,
      quantity: product.quantity,
      message: message,
    );

    // Verificar si el producto ya existe en el carrito
    final existingIndex = _newCartItems.indexWhere((item) => item.productId == product.id);
    CartItem? originalItem;

    if (existingIndex != -1) {
      // Guardar el item original para poder revertir si hay error
      originalItem = _newCartItems[existingIndex];
      // Si el producto ya existe, aumentar la cantidad
      _newCartItems[existingIndex] = originalItem.copyWith(
        quantity: originalItem.quantity + product.quantity,
        message: message.isNotEmpty ? message : originalItem.message,
      );
    } else {
      // Si es un producto nuevo, agregarlo al carrito
      _newCartItems.add(cartItem);
    }

    // Notificar cambio inmediatamente para mostrar en UI
    notifyListeners();

    // Ahora manejar la orden según si existe o no
    Logger.info('Current order entity before operation: ${_currentOrderEntity?.id}');
    
    if (_currentOrderEntity == null) {
      // No existe orden: crear una nueva
      Logger.info('No current order, creating new one');
      await _createInitialOrder();
    } else {
      // Existe orden: modificarla (agregar producto)
      Logger.info('Current order exists: ${_currentOrderEntity!.id}, updating it');
      await _updateExistingOrder();
    }

    // Si hubo error, revertir el cambio en el carrito
    if (status == OrderStatus.error) {
      if (existingIndex != -1 && originalItem != null) {
        // Revertir a la cantidad original
        _newCartItems[existingIndex] = originalItem;
      } else {
        // Remover el producto que se agregó
        _newCartItems.removeLast();
      }
      Logger.error('Failed to add product to cart: $errorMessage');
    } else {
      // Éxito: actualizar estado
      enableSendToKitchen = true;
      _productCount = 1;
      Logger.info('Product added to cart and order updated: ${product.name} x${product.quantity}');
    }

    notifyListeners();
  }

  // Crear orden inicial la primera vez
  Future<void> _createInitialOrder() async {
    status = OrderStatus.loading;
    notifyListeners();

    try {
      final orderRequest = _buildNewOrderRequest();
      Logger.info('Creating initial order with ${_newCartItems.length} products');
      
      final result = await createOrderNewUseCase.call(orderRequest);

      result.fold(
        (failure) {
          Logger.error('Error creating initial order: ${failure.message}');
          status = OrderStatus.error;
          errorMessage = failure.message;
        },
        (order) {
          Logger.info('Initial order created successfully: ${order.id}');
          Logger.info('Order details - ID: ${order.id}, Mesa: ${order.mesa}, Total: ${order.total}');
          _currentOrderEntity = order;
          Logger.info('_currentOrderEntity set to: ${_currentOrderEntity?.id}');
          status = OrderStatus.success;
          errorMessage = null;
          
          Logger.info('Initial order creation completed successfully');
        },
      );
    } catch (e) {
      Logger.error('Unexpected error creating initial order: $e');
      status = OrderStatus.error;
      errorMessage = 'Error inesperado al crear la orden';
    }

    notifyListeners();
  }

  // Modificar orden existente cuando se agrega un producto
  Future<void> _updateExistingOrder() async {
    Logger.info('_updateExistingOrder called - _currentOrderEntity: ${_currentOrderEntity?.id}');
    
    if (_currentOrderEntity == null || _currentOrderEntity!.id.isEmpty) {
      Logger.error('Cannot update order: currentOrderEntity is null or ID is empty');
      Logger.error('_currentOrderEntity: $_currentOrderEntity');
      Logger.error('Available orders: ${_newOrders.map((o) => o.id).toList()}');
      status = OrderStatus.error;
      errorMessage = 'Error: No hay orden actual válida para actualizar';
      notifyListeners();
      return;
    }

    status = OrderStatus.loading;
    notifyListeners();

    try {
      final orderRequest = _buildNewOrderRequest();
      Logger.info('Updating existing order: ${_currentOrderEntity!.id} with ${_newCartItems.length} products');
      Logger.info('Order entity details - ID: ${_currentOrderEntity!.id}, Mesa: ${_currentOrderEntity!.mesa}');
      
      final result = await updateOrderUseCase.call(_currentOrderEntity!.id, orderRequest);

      result.fold(
        (failure) {
          Logger.error('Error updating existing order: ${failure.message}');
          status = OrderStatus.error;
          errorMessage = failure.message;
        },
        (updatedOrder) {
          Logger.info('Existing order updated successfully: ${updatedOrder.id}');
          _currentOrderEntity = updatedOrder;
          status = OrderStatus.success;
          errorMessage = null;
          
          // Refrescar la lista de órdenes
          getAllNewOrders();
        },
      );
    } catch (e) {
      Logger.error('Unexpected error updating existing order: $e');
      status = OrderStatus.error;
      errorMessage = 'Error inesperado al actualizar la orden';
    }

    notifyListeners();
  }

  void removeProductFromNewCart(String productId) {
    _newCartItems.removeWhere((item) => item.productId == productId);
    enableSendToKitchen = hasCartItems;
    Logger.info('Product removed from new cart: $productId');
    notifyListeners();
  }

  void updateCartItemQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeProductFromNewCart(productId);
      return;
    }

    final index = _newCartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _newCartItems[index] = _newCartItems[index].copyWith(quantity: newQuantity);
      Logger.info('Cart item quantity updated: $productId = $newQuantity');
      notifyListeners();
    }
  }



  void clearNewCart() {
    _newCartItems.clear();
    enableSendToKitchen = false;
    Logger.info('New cart cleared');
    notifyListeners();
  }

  // Método simplificado para agregar productos (mantener compatibilidad)
  void addProductToCart(Product product) {
    // Redirigir al nuevo método
    addProductToNewCart(product);
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

  Future<void> getAllNewOrders() async {
    Logger.info('Provider: Getting all new orders from localhost:3000');
    status = OrderStatus.loading;
    notifyListeners();

    var result = await getAllOrdersNewUseCase.call();

    result.fold(
      (failure) {
        status = OrderStatus.error;
        errorMessage = failure.message;
        Logger.error('Error obteniendo nuevas órdenes: ${failure.message}');
        notifyListeners();
      },
      (orders) {
        _newOrders = orders;
        status = OrderStatus.success;
        errorMessage = '';
        _isLoadingAllOrders = false;
        Logger.info('Nuevas órdenes obtenidas exitosamente: ${orders.length}');
        
        // Si no hay orden actual pero hay órdenes disponibles, cargar una
        if (_currentOrderEntity == null && orders.isNotEmpty) {
          Logger.info('No current order but orders available, loading from existing');
          loadCurrentOrderFromExisting();
        } else {
          Logger.info('Current order status - _currentOrderEntity: ${_currentOrderEntity?.id}, orders count: ${orders.length}');
        }
        
        notifyListeners();
      },
    );
  }

  // Crear orden usando la nueva arquitectura
  Future<void> createNewOrder() async {
    if (_newCartItems.isEmpty) {
      errorMessage = "El carrito está vacío";
      status = OrderStatus.error;
      notifyListeners();
      return;
    }

    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      errorMessage = validationError;
      status = OrderStatus.error;
      notifyListeners();
      return;
    }

    status = OrderStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      // Construir la petición
      final orderRequest = _buildNewOrderRequest();
      
      Logger.info('Creating new order with ${_newCartItems.length} products');
      
      // Llamar al use case
      final result = await createOrderNewUseCase.call(orderRequest);

      result.fold(
        (failure) {
          Logger.error('Error creating new order: ${failure.message}');
          status = OrderStatus.error;
          errorMessage = failure.message;
        },
        (order) {
          Logger.info('New order created successfully: ${order.id}');
          status = OrderStatus.success;
          errorMessage = null;
          
          // Limpiar el carrito después de crear la orden exitosamente
          _newCartItems.clear();
          enableSendToKitchen = false;
          
          // Refrescar la lista de órdenes
          getAllNewOrders();
        },
      );
    } catch (e) {
      Logger.error('Unexpected error creating new order: $e');
      status = OrderStatus.error;
      errorMessage = 'Error inesperado al crear la orden';
    }

    notifyListeners();
  }

  // Enviar a cocina (sincronizar cambios pendientes con el backend)
  Future<void> sendToKitchen() async {
    if (_currentOrderEntity == null) {
      errorMessage = "No hay orden actual para enviar a cocina";
      status = OrderStatus.error;
      notifyListeners();
      return;
    }

    if (_newCartItems.isEmpty) {
      errorMessage = "El carrito está vacío";
      status = OrderStatus.error;
      notifyListeners();
      return;
    }

    status = OrderStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      // Construir la petición de modificación
      final orderRequest = _buildNewOrderRequest();
      
      Logger.info('Sending to kitchen - updating order: ${_currentOrderEntity!.id}');
      
      // Usar el use case para PUT /orders/:id
      final result = await updateOrderUseCase.call(_currentOrderEntity!.id, orderRequest);
      
      result.fold(
        (failure) {
          Logger.error('Error updating order: ${failure.message}');
          status = OrderStatus.error;
          errorMessage = failure.message;
        },
        (updatedOrder) {
          Logger.info('Order sent to kitchen successfully: ${updatedOrder.id}');
          status = OrderStatus.success;
          errorMessage = null;
          Logger.info('Status set to success, errorMessage cleared');
          
          // Actualizar la orden actual con los datos del servidor
          _currentOrderEntity = updatedOrder;
          
          // Ahora que la orden está actualizada, verificar cambios
          // (debería deshabilitar el botón ya que no hay diferencias)
          _checkForChanges();
          
          Logger.info('Send to kitchen completed successfully');
        },
      );
    } catch (e) {
      Logger.error('Unexpected error sending to kitchen: $e');
      status = OrderStatus.error;
      errorMessage = 'Error inesperado al enviar a cocina';
    }

    notifyListeners();
  }

  // Cerrar orden (enviar a caja)
  Future<void> closeOrder() async {
    if (_currentOrderEntity == null) {
      errorMessage = "No hay orden actual para cerrar";
      status = OrderStatus.error;
      notifyListeners();
      return;
    }

    status = OrderStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      Logger.info('Closing order: ${_currentOrderEntity!.id}');
      
      final result = await closeOrderUseCase.call(_currentOrderEntity!.id);
      
      result.fold(
        (failure) {
          Logger.error('Error closing order: ${failure.message}');
          status = OrderStatus.error;
          errorMessage = failure.message;
        },
        (closedOrder) {
          Logger.info('Order closed successfully: ${closedOrder.id}');
          status = OrderStatus.success;
          errorMessage = null;
          
          // Limpiar el estado después de cerrar la orden
          _newCartItems.clear();
          _currentOrderEntity = null;
          enableSendToKitchen = false;
          enableCloseBill = false;
          
          Logger.info('Order closed and state cleared');
        },
      );
    } catch (e) {
      Logger.error('Unexpected error closing order: $e');
      status = OrderStatus.error;
      errorMessage = 'Error inesperado al cerrar la orden';
    }

    notifyListeners();
  }

  CreateOrderRequestModel _buildNewOrderRequest() {
    // Mapear tipo de orden
    String orderType;
    switch (_selectedIndex) {
      case 0:
        orderType = 'table';
        break;
      case 1:
        orderType = 'delivery';
        break;
      case 2:
        orderType = 'takeout';
        break;
      default:
        orderType = 'table';
    }

    // Convertir items del carrito a productos solicitados
    final requestedProducts = _newCartItems.map((item) {
      // Crear estados por cantidad (todos empiezan como "pendiente")
      final statusByQuantity = List.generate(
        item.quantity,
        (index) => ProductStatusModel(status: 'pendiente'),
      );

      return RequestedProductModel(
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        requestedQuantity: item.quantity,
        message: item.message,
        statusByQuantity: statusByQuantity,
      );
    }).toList();

    return CreateOrderRequestModel(
      orderType: orderType,
      table: orderType == 'table' ? _tableIndex : 0,
      peopleCount: orderType == 'table' ? _peopleCount : 1,
      requestedProducts: requestedProducts,
      itemCount: totalCartItems,
      total: cartTotal,
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
