import 'dart:async';
import 'dart:convert';
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
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders_new.dart';
import 'package:ordena_ya/domain/usecase/create_order_new.dart';
import 'package:ordena_ya/domain/usecase/update_order.dart';
import 'package:ordena_ya/domain/usecase/close_order.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/data/model/enriched_order_model.dart';
import 'package:ordena_ya/data/datasource/enriched_order_datasource.dart';
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
  final EnrichedOrderRemoteDataSource? enrichedOrderDataSource;

  OrderSetupProvider({
    required this.createOrderUseCase,
    required this.addItemToOrderUseCase,
    required this.getAllOrdersUseCase,
    required this.getAllOrdersNewUseCase,
    required this.createOrderNewUseCase,
    required this.updateOrderUseCase,
    required this.closeOrderUseCase,
    this.enrichedOrderDataSource,
  }) {
    // Inicializar sincronización automática cada 10 segundos
    _startAutoSync();
  }

  Timer? _autoSyncTimer;

  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    // Deshabilitado temporalmente para debugging
    // _autoSyncTimer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   if (_currentOrderEntity != null) {
    //     Logger.info('🔄 Auto-sync: Refreshing cart states...');
    //     refreshCartStatesFromBackend();
    //   }
    // });
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  OrderStatus status = OrderStatus.initial;
  String? _errorMessage = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String cedula = '';
  String email = '';

  String _tableId = ''; // ID de la mesa seleccionada (vacío = no seleccionada)
  String _clientId = '';
  RestaurantTable? _selectedTableInfo; // Información completa de la mesa seleccionada

  int _clienteStep = 0;
  int _discountStep = 0;

  bool _enableSendToKitchen = false;
  bool _enableCloseBill = false;

  int _selectedIndex = 0;
  int _currentIndex = 0;
  int _currentMenu = 0;
  int _peopleCount = 1;
  int _productCount = 1;
  List<Order> _orders = [];
  List<OrderResponseEntity> _newOrders = [];
  List<EnrichedOrderModel> _enrichedOrders = [];
  final PageController _pageController = PageController();

  final List<Product> _cartItems = [];
  final List<CartItem> _newCartItems = []; // Nuevo carrito usando CartItem



  int _selectedTabIndex = 0;
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
  bool get isEditingOrder => _currentOrderEntity != null;
  String? get errorMessage => _errorMessage;
  String get selectedDiscount => _selectedDiscount;
  String get selectedPeople => _selectedPeople;
  String get selectedClient => _selectedClient;
  String get clientId => _clientId;
  bool get isLoadingAllOrders => _isLoadingAllOrders;
  RestaurantTable? get selectedTableInfo => _selectedTableInfo;
  
  // Getter para debuggear el estado de la mesa
  String get tableDebugInfo => 'tableId: $_tableId, selectedTableInfo: ${_selectedTableInfo != null ? '${_selectedTableInfo!.tableNumber} (ID: ${_selectedTableInfo!.id}, ${_selectedTableInfo!.status})' : 'NULL'}';
  
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
      Logger.info('Current config - tableId: $_tableId, orderType: ${_getOrderTypeString()}');
      
      // Por ahora, tomar la primera orden disponible para debuggear
      final matchingOrder = _newOrders.first;
      
      Logger.info('Selected order - ID: ${matchingOrder.id}, Mesa: ${matchingOrder.mesa}, Tipo: ${matchingOrder.tipoPedido}, Estado: ${matchingOrder.estadoGeneral}');
      
      _currentOrderEntity = matchingOrder;
      Logger.info('_currentOrderEntity assigned - ID: ${_currentOrderEntity?.id}');
      
      // Actualizar valores actuales con los de la orden
      _tableId = matchingOrder.mesa.toString(); // Mantener conversión aquí porque mesa sigue siendo int
      _peopleCount = matchingOrder.cantidadPersonas;
      _selectedIndex = _getIndexFromOrderType(matchingOrder.tipoPedido);
      
      Logger.info('Loaded order values - Table: $_tableId, People: $_peopleCount, Type: $_selectedIndex');
      
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

  // Métodos para manejar items del carrito con sincronización al backend
  Future<void> increaseCartItemQuantity(int index) async {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      
      // Aumentar cantidad siempre está permitido
      if (canIncreaseProductQuantity(item.productId)) {
        final oldQuantity = item.quantity;
        _newCartItems[index] = item.copyWith(quantity: item.quantity + 1);
        Logger.info('✅ Increased quantity for ${item.productName}: $oldQuantity → ${item.quantity + 1}');
        
        // Verificar cambios respecto a la orden actual
        _checkForChanges();
        notifyListeners();

        // Si hay una orden actual, enviar cambios al backend
        if (_currentOrderEntity != null) {
          Logger.info('📤 Sending quantity increase to backend');
          await _updateExistingOrder();
          
          // Si hubo error, revertir el cambio
          if (status == OrderStatus.error) {
            _newCartItems[index] = item.copyWith(quantity: oldQuantity);
            Logger.error('Failed to increase quantity, reverted local change');
            notifyListeners();
          }
        }
      }
    }
  }

  Future<void> decreaseCartItemQuantity(int index) async {
    Logger.info('🔽 DECREASE CALLED - index: $index, items count: ${_newCartItems.length}');
    
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      Logger.info('🔽 Item found: ${item.productName}, quantity: ${item.quantity}');
      
      if (item.quantity > 1) {
        Logger.info('🔽 Quantity > 1, checking if can decrease...');
        
        // Validar si se puede reducir cantidad
        if (canDecreaseProductQuantity(item.productId)) {
          Logger.info('🔽 CAN DECREASE - Proceeding with decrease');
          final oldQuantity = item.quantity;
          _newCartItems[index] = item.copyWith(quantity: item.quantity - 1);
          Logger.info('✅ Decreased quantity for ${item.productName}: $oldQuantity → ${item.quantity - 1}');
          
          // Verificar cambios respecto a la orden actual
          _checkForChanges();
          notifyListeners();

          // Si hay una orden actual, enviar cambios al backend
          if (_currentOrderEntity != null) {
            Logger.info('📤 Sending quantity decrease to backend');
            await _updateExistingOrder();
            
            // Si hubo error, revertir el cambio
            if (status == OrderStatus.error) {
              _newCartItems[index] = item.copyWith(quantity: oldQuantity);
              Logger.error('Failed to decrease quantity, reverted local change');
              notifyListeners();
            }
          }
        } else {
          Logger.warning('❌ Cannot decrease quantity for ${item.productName}: has non-pending units');
          _errorMessage = "No se puede disminuir la cantidad: existen unidades que ya están siendo preparadas o entregadas.";
          notifyListeners();
        }
      } else {
        Logger.warning('🔽 Cannot decrease: quantity is 1 or less');
      }
    } else {
      Logger.error('🔽 Invalid index: $index, items count: ${_newCartItems.length}');
    }
  }

  /// Verifica si se puede reducir cantidad para mostrar en UI
  bool canDecreaseQuantityAt(int index) {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      
      // Si no hay estados definidos (producto nuevo), permitir si quantity > 1
      if (item.unitStates.isEmpty) {
        return item.quantity > 1;
      }
      
      // Contar unidades pendientes disponibles
      final pendingCount = item.unitStates
          .where((state) => state.toLowerCase() == 'pendiente')
          .length;
      
      Logger.info('🔍 canDecreaseQuantityAt($index) for ${item.productName}:');
      Logger.info('  - Total quantity: ${item.quantity}');
      Logger.info('  - Pending units: $pendingCount');
      Logger.info('  - Unit states: ${item.unitStates}');
      
      // Permitir disminuir si hay unidades pendientes disponibles y quantity > 1
      // El backend se encarga de eliminar las unidades correctas inteligentemente
      final canDecrease = pendingCount > 0 && item.quantity > 1;
      Logger.info('  - Can decrease: $canDecrease');
      
      return canDecrease;
    }
    return false;
  }

  /// Verifica si se puede eliminar producto para mostrar en UI
  bool canRemoveProductAt(int index) {
    if (index >= 0 && index < _newCartItems.length) {
      final item = _newCartItems[index];
      
      // Si no hay estados definidos (producto nuevo), permitir eliminar
      if (item.unitStates.isEmpty) {
        return true;
      }
      
      // Solo permitir eliminar si todas las unidades están pendientes
      return item.unitStates.every((state) => state.toLowerCase() == 'pendiente');
    }
    return false;
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
      
      // VALIDAR SI SE PUEDE ELIMINAR
      if (!canRemoveProduct(removedItem.productId)) {
        Logger.warning('❌ Cannot remove ${removedItem.productName}: has non-pending units');
        _errorMessage = "No se puede eliminar el producto: existen unidades que ya están siendo preparadas o entregadas.";
        notifyListeners();
        return;
      }
      
      _newCartItems.removeAt(index);
      
      Logger.info('✅ Product removed from cart: ${removedItem.productName}');
      Logger.info('Cart items remaining: ${_newCartItems.length}');
      
      // SIEMPRE ENVIAR AL BACKEND - Dejar que el backend decida qué hacer
      if (_currentOrderEntity != null) {
        Logger.info('📤 Sending updated cart to backend (${_newCartItems.length} items) - ACTION: EDIT_ORDER');
        await _updateExistingOrder();
        
        // Si hubo error, revertir el cambio
        if (status == OrderStatus.error) {
          _newCartItems.insert(index, removedItem);
          Logger.error('Failed to remove product from order, reverted local change');
        } else {
          // Si el backend respondió exitosamente, verificar si eliminó la orden
          Logger.info('✅ Backend processed removal successfully');
          
          // Si el carrito quedó vacío y no hay error, la orden fue eliminada
          if (_newCartItems.isEmpty) {
            Logger.info('🔄 Cart is empty after removal - Order was deleted by backend');
            _resetOrderState();
          }
        }
      } else {
        Logger.info('⚠️ No current order to update');
      }
      
      // Verificar cambios respecto a la orden actual
      _checkForChanges();
      notifyListeners();
    }
  }

  // Método para resetear el estado cuando el carrito queda vacío
  void _resetOrderState() {
    Logger.info('🔄 Resetting order state to initial');
    
    // Limpiar referencia a la orden actual
    _currentOrderEntity = null;
    
    // Resetear estado
    status = OrderStatus.initial;
    errorMessage = null;
    
    // Deshabilitar botones
    enableSendToKitchen = false;
    enableCloseBill = false;
    
    Logger.info('✅ Order state reset completed - Ready for new order');
  }

  // VALIDACIONES PARA ACCIONES DE EDICIÓN
  
  /// Verifica si se puede reducir la cantidad de un producto
  bool canDecreaseProductQuantity(String productId) {
    // Buscar el item en el carrito para verificar sus estados
    final cartItem = _newCartItems
        .where((item) => item.productId == productId)
        .firstOrNull;

    if (cartItem == null) return true; // No encontrado, permitir

    // Si no tiene estados definidos, es un producto nuevo, permitir
    if (cartItem.unitStates.isEmpty) return true;

    // Contar unidades pendientes disponibles
    final pendingCount = cartItem.unitStates
        .where((state) => state.toLowerCase() == 'pendiente')
        .length;

    Logger.info('🔍 canDecreaseProductQuantity for ${cartItem.productName}:');
    Logger.info('  - Total quantity: ${cartItem.quantity}');
    Logger.info('  - Pending units: $pendingCount');
    Logger.info('  - Unit states: ${cartItem.unitStates}');

    // Se puede disminuir si hay unidades pendientes disponibles
    // y la cantidad actual es mayor a 1
    // El backend maneja inteligentemente cuáles unidades eliminar
    final canDecrease = pendingCount > 0 && cartItem.quantity > 1;
    Logger.info('  - Can decrease: $canDecrease');
    
    return canDecrease;
  }
  
  /// Verifica si se puede eliminar un producto completamente
  bool canRemoveProduct(String productId) {
    // Buscar el item en el carrito para verificar sus estados
    final cartItem = _newCartItems
        .where((item) => item.productId == productId)
        .firstOrNull;

    if (cartItem == null) return true; // No encontrado, permitir

    // Si no tiene estados definidos, es un producto nuevo, permitir
    if (cartItem.unitStates.isEmpty) return true;

    // Verificar que todas las unidades estén pendientes
    return cartItem.unitStates.every((state) => state.toLowerCase() == 'pendiente');
  }
  
  /// Verifica si se puede aumentar la cantidad (siempre permitido)
  bool canIncreaseProductQuantity(String productId) {
    return true; // Aumentar cantidad siempre está permitido
  }
  
  /// Obtiene el mensaje de error para mostrar al usuario
  String getEditRestrictionMessage() {
    return "No se puede editar la orden: existen unidades con estado no pendiente.";
  }

  /// Método de prueba para validar la lógica de decrease
  void testDecreaseLogic() {
    Logger.info('🧪 TESTING NEW DECREASE LOGIC');
    
    // Crear un item de prueba con estados mixtos
    final testItem = CartItem(
      productId: 'test-product',
      productName: 'Test Product',
      price: 10.0,
      quantity: 4,
      message: '',
      unitStates: ['pendiente', 'cocinando', 'pendiente', 'cocinando'],
    );
    
    Logger.info('Test item: ${testItem.productName}');
    Logger.info('Quantity: ${testItem.quantity}');
    Logger.info('Unit states: ${testItem.unitStates}');
    Logger.info('Pending units: ${testItem.pendingUnitsCount}');
    Logger.info('Can decrease (entity): ${testItem.canDecrease}');
    
    // Agregar temporalmente al carrito para probar
    _newCartItems.add(testItem);
    final index = _newCartItems.length - 1;
    
    Logger.info('Can decrease (provider): ${canDecreaseQuantityAt(index)}');
    Logger.info('Can decrease product: ${canDecreaseProductQuantity(testItem.productId)}');
    
    // Limpiar
    _newCartItems.removeAt(index);
    
    Logger.info('✅ New logic: Frontend solo verifica unidades pendientes disponibles');
    Logger.info('✅ Backend maneja inteligentemente cuáles eliminar');
  }

  /// Convierte errores del backend a mensajes amigables
  String _getErrorMessage(String originalError) {
    // Detectar errores específicos de edición de órdenes
    if (originalError.contains('No se puede reducir') && originalError.contains('no están en estado "pendiente"')) {
      return 'No se puede reducir la cantidad: algunas unidades ya están siendo preparadas o entregadas.';
    }
    
    if (originalError.contains('Edición rechazada')) {
      return 'No se puede realizar la edición: existen unidades que ya están en proceso.';
    }
    
    // Detectar errores comunes y convertirlos a mensajes amigables
    if (originalError.contains('404') || originalError.contains('no encontrada')) {
      return 'La orden ya no existe. Es posible que haya sido eliminada.';
    }
    
    if (originalError.contains('400') || originalError.contains('Bad Request')) {
      return 'Los datos enviados no son válidos. Por favor, revisa la información.';
    }
    
    if (originalError.contains('500') || originalError.contains('Internal Server Error')) {
      return 'Error interno del servidor. Por favor, intenta nuevamente.';
    }
    
    if (originalError.contains('network') || originalError.contains('connection')) {
      return 'Error de conexión. Verifica tu conexión a internet.';
    }
    
    if (originalError.contains('timeout')) {
      return 'La operación tardó demasiado tiempo. Intenta nuevamente.';
    }
    
    // Si no es un error conocido, devolver el mensaje original pero más limpio
    return originalError.length > 100 
        ? 'Ha ocurrido un error. Por favor, intenta nuevamente.'
        : originalError;
  }

  /// Método helper para cargar una orden existente en el carrito para edición
  /// Este método debe ser llamado cuando se quiere editar una orden existente
  void loadOrderForEditing(OrderResponseEntity order) {
    // Almacenar la orden que se está editando
    _currentOrderEntity = order;
    
    // Limpiar carrito actual
    _newCartItems.clear();

    // Convertir productos de la orden a items del carrito
    for (final orderProduct in order.productosSolicitados) {
      // Extraer los estados de las unidades
      final unitStates = orderProduct.estadosPorCantidad.map((estado) => estado.estado).toList();

      // Crear item del carrito con los estados
      final cartItem = CartItem(
        productId: orderProduct.productId,
        productName: orderProduct.nombreProducto,
        price: orderProduct.price,
        quantity: orderProduct.cantidadSolicitada,
        message: orderProduct.mensaje,
        unitStates: unitStates,
      );

      _newCartItems.add(cartItem);
    }

    notifyListeners();
  }

  /// Envía los cambios del carrito al backend para actualizar la orden existente
  Future<void> _updateExistingOrder() async {
    if (_currentOrderEntity == null) {
      Logger.warning('No hay orden actual para actualizar');
      return;
    }

    status = OrderStatus.loading;
    notifyListeners();

    try {
      // Construir la petición con los productos actuales del carrito
      final requestedProducts = _newCartItems.map((item) {
        return RequestedProductModel(
          productId: item.productId,
          requestedQuantity: item.quantity,
          message: item.message,
        );
      }).toList();

      final orderRequest = CreateOrderRequestModel(
        orderType: _getOrderTypeFromTipoPedido(_currentOrderEntity!.tipoPedido),
        tableId: _currentOrderEntity!.mesa.toString(),
        peopleCount: _currentOrderEntity!.cantidadPersonas,
        requestedProducts: requestedProducts,
      );

      Logger.info('📤 Updating order ${_currentOrderEntity!.id} with ${requestedProducts.length} products');

      // Llamar al backend
      final result = await updateOrderUseCase.call(_currentOrderEntity!.id, orderRequest);

      result.fold(
        (failure) {
          Logger.error('❌ Error updating order: ${failure.message}');
          
          // Si el error contiene información de la orden actual, actualizarla
          if (failure.message.contains('currentOrder')) {
            try {
              // Extraer la orden actual del mensaje de error
              final errorJson = failure.message.split(' - ').last;
              final errorData = json.decode(errorJson);
              if (errorData['currentOrder'] != null) {
                // Parsear la orden actual y actualizar estados
                final currentOrderData = errorData['currentOrder'];
                Logger.info('🔄 Updating cart states from error response');
                _updateCartStatesFromErrorResponse(currentOrderData);
              }
            } catch (e) {
              Logger.warning('Failed to parse error response for order update: $e');
            }
          }
          
          status = OrderStatus.error;
          _errorMessage = _getErrorMessage(failure.message);
        },
        (updatedOrder) {
          Logger.info('✅ Order updated successfully');
          status = OrderStatus.success;
          _errorMessage = null;
          
          // Actualizar la orden actual con la respuesta del backend
          _currentOrderEntity = updatedOrder;
          
          // Actualizar los estados de las unidades en el carrito
          _updateCartItemStatesFromOrder(updatedOrder);
          
          // Refrescar la lista de órdenes para que se vea el cambio
          _refreshOrdersList();
        },
      );
    } catch (e) {
      Logger.error('❌ Unexpected error updating order: $e');
      status = OrderStatus.error;
      _errorMessage = _getErrorMessage(e.toString());
    }

    notifyListeners();
  }

  /// Actualiza los estados de las unidades en el carrito basándose en la orden actualizada
  void _updateCartItemStatesFromOrder(OrderResponseEntity order) {
    Logger.info('🔄 Updating cart states from backend order...');
    
    for (int i = 0; i < _newCartItems.length; i++) {
      final cartItem = _newCartItems[i];
      
      // Buscar el producto correspondiente en la orden
      final orderProduct = order.productosSolicitados
          .where((p) => p.productId == cartItem.productId)
          .firstOrNull;

      if (orderProduct != null) {
        // Extraer los estados de las unidades
        final unitStates = orderProduct.estadosPorCantidad.map((estado) => estado.estado).toList();
        final backendQuantity = orderProduct.cantidadSolicitada;
        
        Logger.info('📦 Updating ${cartItem.productName}:');
        Logger.info('  - Frontend quantity: ${cartItem.quantity} -> Backend quantity: $backendQuantity');
        Logger.info('  - Frontend states: ${cartItem.unitStates} -> Backend states: $unitStates');
        
        // Actualizar el item del carrito con los estados Y la cantidad del backend
        _newCartItems[i] = cartItem.copyWith(
          unitStates: unitStates,
          quantity: backendQuantity, // IMPORTANTE: Sincronizar cantidad también
        );
        
        Logger.info('  - ✅ Updated successfully');
      } else {
        Logger.warning('  - ⚠️ Product ${cartItem.productName} not found in backend order');
      }
    }
    
    Logger.info('🔄 Cart states update completed');
  }

  /// Actualiza los estados del carrito desde una respuesta de error del backend
  void _updateCartStatesFromErrorResponse(Map<String, dynamic> currentOrderData) {
    try {
      final requestedProducts = currentOrderData['requestedProducts'] as List<dynamic>?;
      if (requestedProducts == null) return;

      for (int i = 0; i < _newCartItems.length; i++) {
        final cartItem = _newCartItems[i];
        
        // Buscar el producto correspondiente en la respuesta de error
        final orderProduct = requestedProducts
            .where((p) => p['productId'] == cartItem.productId)
            .firstOrNull;

        if (orderProduct != null) {
          // Extraer los estados de las unidades
          final statusByQuantity = orderProduct['statusByQuantity'] as List<dynamic>?;
          if (statusByQuantity != null) {
            final unitStates = statusByQuantity
                .map((estado) => estado['status'] as String)
                .toList();
            
            // Actualizar el item del carrito con los estados actuales
            _newCartItems[i] = cartItem.copyWith(
              unitStates: unitStates,
              quantity: statusByQuantity.length, // Asegurar que la cantidad coincida
            );
            
            Logger.info('🔄 Updated ${cartItem.productName} states: $unitStates');
          }
        }
      }
    } catch (e) {
      Logger.error('Error updating cart states from error response: $e');
    }
  }

  /// Convierte el tipo de pedido de la orden a formato del request
  String _getOrderTypeFromTipoPedido(String tipoPedido) {
    switch (tipoPedido.toLowerCase()) {
      case 'mesa':
        return 'table';
      case 'domicilio':
        return 'delivery';
      case 'recoger':
        return 'takeout';
      default:
        return 'table';
    }
  }

  /// Refresca la lista de órdenes para mostrar los cambios
  Future<void> _refreshOrdersList() async {
    Logger.info('🔄 Refreshing orders list...');
    await getAllNewOrders();
  }

  /// Fuerza la actualización de estados desde el backend
  Future<void> refreshCartStatesFromBackend() async {
    if (_currentOrderEntity == null) return;
    
    Logger.info('🔄 Refreshing cart states from backend...');
    
    try {
      // Obtener la orden actual del backend
      await getAllNewOrders();
      
      // Buscar la orden actual en la lista actualizada
      final currentOrder = _newOrders
          .where((order) => order.id == _currentOrderEntity!.id)
          .firstOrNull;
          
      if (currentOrder != null) {
        Logger.info('✅ Found current order, updating states');
        _updateCartItemStatesFromOrder(currentOrder);
        _currentOrderEntity = currentOrder;
        notifyListeners();
      } else {
        Logger.warning('⚠️ Current order not found in backend response');
      }
    } catch (e) {
      Logger.error('❌ Error refreshing cart states: $e');
    }
  }

  /// MÉTODO DE DIAGNÓSTICO - Para debuggear el problema
  void debugCartStates() {
    Logger.info('🔍 === DIAGNÓSTICO DE ESTADOS DEL CARRITO ===');
    Logger.info('Current order ID: ${_currentOrderEntity?.id ?? "NULL"}');
    Logger.info('Cart items count: ${_newCartItems.length}');
    
    for (int i = 0; i < _newCartItems.length; i++) {
      final item = _newCartItems[i];
      Logger.info('--- Item $i: ${item.productName} ---');
      Logger.info('  Product ID: ${item.productId}');
      Logger.info('  Quantity: ${item.quantity}');
      Logger.info('  Unit states: ${item.unitStates}');
      Logger.info('  Pending units: ${item.pendingUnitsCount}');
      Logger.info('  Can decrease: ${canDecreaseQuantityAt(i)}');
      Logger.info('  Can remove: ${canRemoveProductAt(i)}');
    }
    
    if (_currentOrderEntity != null) {
      Logger.info('--- Backend Order Data ---');
      for (final product in _currentOrderEntity!.productosSolicitados) {
        Logger.info('Backend Product: ${product.nombreProducto}');
        Logger.info('  Product ID: ${product.productId}');
        Logger.info('  Quantity: ${product.cantidadSolicitada}');
        final states = product.estadosPorCantidad.map((e) => e.estado).toList();
        Logger.info('  Backend states: $states');
      }
    }
    
    Logger.info('🔍 === FIN DIAGNÓSTICO ===');
  }

  /// MÉTODO DE PRUEBA - Fuerza sincronización inmediata
  Future<void> forceSyncWithBackend() async {
    Logger.info('🚀 FORZANDO SINCRONIZACIÓN CON BACKEND...');
    
    if (_currentOrderEntity == null) {
      Logger.error('❌ No hay orden actual para sincronizar');
      return;
    }

    try {
      // 1. Obtener datos frescos del backend
      Logger.info('📡 Obteniendo datos frescos del backend...');
      await getAllNewOrders();
      
      // 2. Buscar la orden actual
      final freshOrder = _newOrders
          .where((order) => order.id == _currentOrderEntity!.id)
          .firstOrNull;
      
      if (freshOrder == null) {
        Logger.error('❌ Orden no encontrada en el backend');
        return;
      }
      
      Logger.info('✅ Orden encontrada en backend');
      
      // 3. Comparar datos
      Logger.info('🔍 COMPARANDO DATOS:');
      Logger.info('Frontend order ID: ${_currentOrderEntity!.id}');
      Logger.info('Backend order ID: ${freshOrder.id}');
      
      // 4. Actualizar estados
      Logger.info('🔄 Actualizando estados...');
      _currentOrderEntity = freshOrder;
      _updateCartItemStatesFromOrder(freshOrder);
      
      // 5. Notificar cambios
      notifyListeners();
      
      Logger.info('✅ SINCRONIZACIÓN COMPLETADA');
      
    } catch (e) {
      Logger.error('❌ Error en sincronización forzada: $e');
    }
  }

  /// Método de ejemplo para simular una orden con diferentes estados
  /// Solo para testing - eliminar en producción
  void simulateOrderWithMixedStates() {
    _newCartItems.clear();

    // Producto 1: Todas las unidades pendientes (se puede editar)
    _newCartItems.add(CartItem(
      productId: '1',
      productName: 'Hamburguesa Clásica',
      price: 15000,
      quantity: 2,
      message: 'Sin cebolla',
      unitStates: ['pendiente', 'pendiente'],
    ));

    // Producto 2: Unidades mixtas (NO se puede editar)
    _newCartItems.add(CartItem(
      productId: '2',
      productName: 'Pizza Margherita',
      price: 25000,
      quantity: 3,
      message: '',
      unitStates: ['pendiente', 'cocinando', 'listo_para_entregar'],
    ));

    // Producto 3: Producto nuevo sin estados (se puede editar)
    _newCartItems.add(CartItem(
      productId: '3',
      productName: 'Coca Cola',
      price: 3000,
      quantity: 1,
      message: '',
      unitStates: [], // Sin estados = producto nuevo
    ));

    notifyListeners();
  }

  /// Limpia el estado de edición y vuelve al modo de crear orden nueva
  void clearEditingOrder() {
    _currentOrderEntity = null;
    _newCartItems.clear();
    Logger.info('🔄 Cleared editing order state');
    notifyListeners();
  }
  
  // TODO: Implement proper client management
  List<String> get clients => ['Cliente 1', 'Cliente 2', 'Cliente 3'];
  int get currentMenu => _currentMenu;
  String get tableId => _tableId; // ID de la mesa seleccionada
  bool get enableSendToKitchen => _enableSendToKitchen;
  bool get enableCloseBill => _enableCloseBill;
  int get peopleCount => _peopleCount;
  int get productCount => _productCount;
  List<Order> get orders => _orders;
  List<OrderResponseEntity> get newOrders => _newOrders;
  List<EnrichedOrderModel> get enrichedOrders => _enrichedOrders;

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

  // Método para establecer la mesa seleccionada (usar este método siempre)
  void setSelectedTable(RestaurantTable table) {
    _selectedTableInfo = table;
    _tableId = table.id;
    _checkForChanges();
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
      bool hasTableChanges = _tableId != _currentOrderEntity!.mesa.toString();
      bool hasPeopleChanges = _peopleCount != _currentOrderEntity!.cantidadPersonas;
      bool hasTypeChanges = _selectedIndex != _getIndexFromOrderType(_currentOrderEntity!.tipoPedido);
      bool hasCartChanges = _hasCartChanges();
      
      bool hasChanges = hasTableChanges || hasPeopleChanges || hasTypeChanges || hasCartChanges;
      
      enableSendToKitchen = hasChanges;
      Logger.info('Changes detected - Table: $_tableId vs ${_currentOrderEntity!.mesa}, People: $_peopleCount vs ${_currentOrderEntity!.cantidadPersonas}, Type: $_selectedIndex vs ${_getIndexFromOrderType(_currentOrderEntity!.tipoPedido)}, Cart: $hasCartChanges, Enable: $enableSendToKitchen');
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
      tableId: int.tryParse(_tableId) ?? 0,
      peopleCount: peopleCountValue,
      consumptionType: consumptionType,
      clientId: clientIdValue,
    );
    return order;
  }

  String? _validateOrderRequirements() {
    switch (_selectedIndex) {
      case 0: // Mesa
        if (_selectedTableInfo == null) {
          return "Debes seleccionar una mesa desde el selector de mesas";
        }

        // Verificar consistencia entre _tableId y _selectedTableInfo
        if (_tableId != _selectedTableInfo!.id) {
          return "Debes seleccionar una mesa desde el selector de mesas";
        }
        // Validar que la mesa esté disponible
        if (_selectedTableInfo!.status == 'occupied') {
          return "La mesa seleccionada está ocupada. Por favor, selecciona otra mesa.";
        }
        if (_selectedTableInfo!.status == 'reserved') {
          return "La mesa seleccionada está reservada. Por favor, selecciona otra mesa.";
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
    cartProvider.setTableNumber(_tableId);
    cartProvider.setPeopleCount(_peopleCount);
    cartProvider.setClientId(_clientId);
  }

  // Métodos para el nuevo carrito
  Future<void> addProductToNewCart(Product product, {String message = ''}) async {
    // Arreglar inconsistencia si existe selectedTableInfo pero tableId está vacío
    if (_selectedTableInfo != null && _tableId.isEmpty) {
      _tableId = _selectedTableInfo!.id;
    }
    
    // Validar requisitos antes de proceder
    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return;
    }

    // Crear el item del carrito con información completa
    final cartItem = CartItem(
      productId: product.id,
      productName: product.name,
      price: product.unitPrice,
      quantity: product.quantity,
      message: message,
      category: product.category,
      description: product.description,
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
    if (_currentOrderEntity == null) {
      // No existe orden: crear una nueva
      Logger.info('🆕 No current order - Creating new order');
      await _createInitialOrder();
    } else {
      // Existe orden: modificarla (agregar producto)
      Logger.info('📝 Current order exists - Updating existing order: ${_currentOrderEntity!.id}');
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
    } else {
      // Éxito: actualizar estado
      enableSendToKitchen = true;
      _productCount = 1;
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
          errorMessage = _getErrorMessage(failure.message);
        },
        (order) {
          Logger.info('Initial order created successfully: ${order.id}');
          Logger.info('Order details - ID: ${order.id}, Mesa: ${order.mesa}, Total: ${order.total}');
          _currentOrderEntity = order;
          Logger.info('_currentOrderEntity set to: ${_currentOrderEntity?.id}');
          
          // Actualizar los estados de las unidades en el carrito
          _updateCartItemStatesFromOrder(order);
          
          status = OrderStatus.success;
          errorMessage = null;
          
          Logger.info('Initial order creation completed successfully');
        },
      );
    } catch (e) {
      Logger.error('Unexpected error creating initial order: $e');
      status = OrderStatus.error;
      errorMessage = _getErrorMessage(e.toString());
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

  // Limpiar selección de mesa
  void clearSelectedTable() {
    _selectedTableInfo = null;
    _tableId = ''; // vacío = no seleccionada
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
    Logger.info('Actualizando mesa: $_tableId, personas: $_peopleCount');
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
        errorMessage = _getErrorMessage(failure.message);
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
        errorMessage = _getErrorMessage(failure.message);
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
        errorMessage = _getErrorMessage(failure.message);
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
    status = OrderStatus.loading;
    notifyListeners();

    var result = await getAllOrdersNewUseCase.call();

    result.fold(
      (failure) {
        status = OrderStatus.error;
        errorMessage = _getErrorMessage(failure.message);
        notifyListeners();
      },
      (orders) {
        _newOrders = orders;
        status = OrderStatus.success;
        errorMessage = '';
        _isLoadingAllOrders = false;
        
        // Si no hay orden actual pero hay órdenes disponibles, cargar una
        if (_currentOrderEntity == null && orders.isNotEmpty) {
          loadCurrentOrderFromExisting();
        }
        
        notifyListeners();
      },
    );
  }

  // Nuevo método para obtener órdenes enriquecidas
  Future<void> getAllEnrichedOrders() async {
    print('DEBUG: getAllEnrichedOrders called');
    print('DEBUG: enrichedOrderDataSource is ${enrichedOrderDataSource != null ? 'AVAILABLE' : 'NULL'}');
    
    if (enrichedOrderDataSource == null) {
      print('DEBUG: No enriched datasource, falling back to regular orders');
      // Fallback al método anterior si no hay datasource enriquecido
      return getAllNewOrders();
    }

    print('DEBUG: Using enriched datasource to fetch orders');
    status = OrderStatus.loading;
    notifyListeners();

    try {
      final orders = await enrichedOrderDataSource!.fetchEnrichedOrders();
      print('DEBUG: Successfully fetched ${orders.length} enriched orders');
      
      // DEBUG: Verificar si realmente son órdenes enriquecidas
      if (orders.isNotEmpty) {
        final firstOrder = orders.first;
        print('DEBUG: First order analysis:');
        print('  - Has tableInfo: ${firstOrder.tableInfo != null}');
        print('  - Has productSnapshot: ${firstOrder.requestedProducts.isNotEmpty ? firstOrder.requestedProducts.first.productSnapshot.name != 'Producto Desconocido' : false}');
        print('  - Total: ${firstOrder.total}');
        print('  - TableId: ${firstOrder.tableId}');
        
        if (firstOrder.tableInfo == null && firstOrder.total == 0) {
          print('⚠️  WARNING: Backend is NOT returning enriched data!');
          print('⚠️  This looks like regular order data, not enriched.');
        }
      }
      
      _enrichedOrders = orders;
      status = OrderStatus.success;
      errorMessage = '';
      _isLoadingAllOrders = false;
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error fetching enriched orders: $e');
      status = OrderStatus.error;
      errorMessage = _getErrorMessage('Error al cargar órdenes: $e');
      notifyListeners();
    }
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
          errorMessage = _getErrorMessage(failure.message);
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
      errorMessage = _getErrorMessage(e.toString());
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
          
          // DETECTAR ERROR 404 - ORDEN NO ENCONTRADA (Backend la eliminó)
          if (failure.message.contains('404') || failure.message.contains('no encontrada')) {
            Logger.info('🔄 Order not found (404) during sendToKitchen - Backend deleted empty order, resetting state');
            _resetOrderState();
            return;
          }
          
          status = OrderStatus.error;
          errorMessage = _getErrorMessage(failure.message);
        },
        (updatedOrder) {
          Logger.info('Order sent to kitchen successfully: ${updatedOrder.id}');
          status = OrderStatus.success;
          errorMessage = null;
          Logger.info('Status set to success, errorMessage cleared');
          
          // Actualizar la orden actual con los datos del servidor
          _currentOrderEntity = updatedOrder;
          
          // Actualizar los estados de las unidades en el carrito
          _updateCartItemStatesFromOrder(updatedOrder);
          
          // Ahora que la orden está actualizada, verificar cambios
          // (debería deshabilitar el botón ya que no hay diferencias)
          _checkForChanges();
          
          Logger.info('Send to kitchen completed successfully');
        },
      );
    } catch (e) {
      Logger.error('Unexpected error sending to kitchen: $e');
      status = OrderStatus.error;
      errorMessage = _getErrorMessage(e.toString());
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
          errorMessage = _getErrorMessage(failure.message);
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
      errorMessage = _getErrorMessage(e.toString());
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

    // Convertir items del carrito a productos solicitados (estructura completa)
    final requestedProducts = _newCartItems.map((item) {
      // Crear productSnapshot con la información completa del producto
      final productSnapshot = ProductSnapshotModel(
        name: item.productName,
        price: item.price,
        category: item.category,
        description: item.description,
      );
      
      // PRESERVAR ESTADOS EXISTENTES O CREAR NUEVOS
      List<ProductStatusModel> statusByQuantity = [];
      
      if (_currentOrderEntity != null) {
        // Buscar el producto en la orden actual para preservar estados
        final existingProduct = _currentOrderEntity!.productosSolicitados
            .where((p) => p.productId == item.productId)
            .firstOrNull;
            
        if (existingProduct != null) {
          // PRODUCTO EXISTENTE: Manejar cambios de cantidad
          final existingStates = existingProduct.estadosPorCantidad;
          
          if (item.quantity == existingStates.length) {
            // Cantidad igual: mantener estados existentes
            statusByQuantity = existingStates
                .map((state) => ProductStatusModel(status: state.estado))
                .toList();
          } else if (item.quantity > existingStates.length) {
            // Cantidad aumentó: mantener existentes + agregar pendientes
            statusByQuantity = existingStates
                .map((state) => ProductStatusModel(status: state.estado))
                .toList();
            // Agregar estados pendientes para las nuevas unidades
            for (int i = existingStates.length; i < item.quantity; i++) {
              statusByQuantity.add(ProductStatusModel(status: 'pendiente'));
            }
          } else {
            // Cantidad disminuyó: mantener solo los primeros estados
            statusByQuantity = existingStates
                .take(item.quantity)
                .map((state) => ProductStatusModel(status: state.estado))
                .toList();
          }
        } else {
          // PRODUCTO NUEVO: crear estados pendientes
          statusByQuantity = List.generate(
            item.quantity,
            (index) => ProductStatusModel(status: 'pendiente'),
          );
        }
      } else {
        // NO HAY ORDEN ACTUAL: crear estados pendientes (orden nueva)
        statusByQuantity = List.generate(
          item.quantity,
          (index) => ProductStatusModel(status: 'pendiente'),
        );
      }
      
      return RequestedProductModel(
        productId: item.productId,
        requestedQuantity: item.quantity,
        message: item.message,
        productSnapshot: productSnapshot,
        statusByQuantity: statusByQuantity,
      );
    }).toList();

    // Debug: verificar valores antes de crear la orden
    Logger.info('🔍 BUILDING ORDER REQUEST:');
    Logger.info('  - orderType: $orderType');
    Logger.info('  - _tableId: $_tableId');
    Logger.info('  - _selectedIndex: $_selectedIndex');
    Logger.info('  - _peopleCount: $_peopleCount');
    Logger.info('  - requestedProducts count: ${requestedProducts.length}');
    
    for (int i = 0; i < requestedProducts.length; i++) {
      final product = requestedProducts[i];
      Logger.info('  - Product $i: ${product.productId} (qty: ${product.requestedQuantity}, msg: "${product.message}")');
      if (product.productSnapshot != null) {
        Logger.info('    * Snapshot: ${product.productSnapshot!.name} - \$${product.productSnapshot!.price} (${product.productSnapshot!.category})');
      }
      if (product.statusByQuantity != null) {
        final statuses = product.statusByQuantity!.map((s) => s.status).join(', ');
        Logger.info('    * Status (${product.statusByQuantity!.length}): [$statuses]');
      }
    }
    
    Logger.info('Table info - selectedTableInfo: ${_selectedTableInfo != null ? '${_selectedTableInfo!.tableNumber} (ID: ${_selectedTableInfo!.id})' : 'NULL'}');
    
    // Validación adicional para mesa
    if (orderType == 'table' && _tableId.isEmpty) {
      Logger.error('ERROR: Trying to create table order but _tableId is empty: $_tableId');
      throw Exception('Mesa no seleccionada correctamente. _tableId: $_tableId');
    }
    
    final orderRequest = CreateOrderRequestModel(
      orderType: orderType,
      tableId: orderType == 'table' ? _tableId : null,
      peopleCount: orderType == 'table' ? _peopleCount : 1,
      requestedProducts: requestedProducts,
    );
    
    Logger.info('📤 FINAL ORDER REQUEST JSON: ${orderRequest.toJson()}');
    
    return orderRequest;
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
