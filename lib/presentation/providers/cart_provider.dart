import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';
import 'package:ordena_ya/domain/entity/cart_item.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/domain/usecase/create_order_new.dart';

enum CartStatus { initial, loading, success, error }

class CartProvider with ChangeNotifier {
  final CreateOrderNewUseCase createOrderNewUseCase;

  CartProvider({
    required this.createOrderNewUseCase,
  });

  // Estado del carrito
  CartStatus _status = CartStatus.initial;
  final List<CartItem> _cartItems = [];
  String? _errorMessage;
  OrderResponseEntity? _createdOrder;

  // Configuración de la orden
  String _orderType = 'table'; // table, delivery, takeout
  int _tableNumber = 1;
  int _peopleCount = 1;
  String _clientId = '';

  // Getters
  CartStatus get status => _status;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  String? get errorMessage => _errorMessage;
  OrderResponseEntity? get createdOrder => _createdOrder;
  String get orderType => _orderType;
  int get tableNumber => _tableNumber;
  int get peopleCount => _peopleCount;
  String get clientId => _clientId;

  bool get hasItems => _cartItems.isNotEmpty;
  bool get isLoading => _status == CartStatus.loading;
  bool get hasError => _status == CartStatus.error;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get tax => subtotal * 0.08; // 8% de impuestos
  
  double get total => subtotal + tax;

  // Setters para configuración de orden
  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  void setTableNumber(int table) {
    _tableNumber = table;
    notifyListeners();
  }

  void setPeopleCount(int count) {
    _peopleCount = count;
    notifyListeners();
  }

  void setClientId(String id) {
    _clientId = id;
    notifyListeners();
  }

  // Validaciones
  String? _validateOrderRequirements() {
    switch (_orderType) {
      case 'table':
        if (_tableNumber <= 0) {
          return "Debes seleccionar una mesa antes de crear tu orden";
        }
        break;
      case 'delivery':
        if (_clientId.isEmpty) {
          return "Debe seleccionar un cliente antes de crear la orden";
        }
        break;
      case 'takeout':
        // No necesita validación adicional
        break;
      default:
        return "Tipo de orden no válido.";
    }
    return null; // Sin errores
  }

  // Gestión del carrito
  void addProductToCart(Product product, {String message = ''}) {
    // Validar requisitos antes de proceder
    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      _errorMessage = validationError;
      _status = CartStatus.error;
      notifyListeners();
      return;
    }

    final existingIndex = _cartItems.indexWhere((item) => item.productId == product.id);

    if (existingIndex != -1) {
      // Si el producto ya existe, aumentar la cantidad
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + product.quantity,
        message: message.isNotEmpty ? message : existingItem.message,
      );
    } else {
      // Si es un producto nuevo, agregarlo al carrito
      final cartItem = CartItem(
        productId: product.id,
        productName: product.name,
        price: product.unitPrice,
        quantity: product.quantity,
        message: message,
      );
      _cartItems.add(cartItem);
    }

    _clearError();
    Logger.info('Product added to cart: ${product.name} x${product.quantity}');
    notifyListeners();
  }

  void removeProductFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    Logger.info('Product removed from cart: $productId');
    notifyListeners();
  }

  void updateProductQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeProductFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      Logger.info('Product quantity updated: $productId = $newQuantity');
      notifyListeners();
    }
  }

  void updateProductMessage(String productId, String message) {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(message: message);
      Logger.info('Product message updated: $productId');
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _createdOrder = null;
    _clearError();
    Logger.info('Cart cleared');
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_status == CartStatus.error) {
      _status = CartStatus.initial;
    }
  }

  // Crear orden
  Future<void> createOrder() async {
    if (_cartItems.isEmpty) {
      _errorMessage = "El carrito está vacío";
      _status = CartStatus.error;
      notifyListeners();
      return;
    }

    final validationError = _validateOrderRequirements();
    if (validationError != null) {
      _errorMessage = validationError;
      _status = CartStatus.error;
      notifyListeners();
      return;
    }

    _status = CartStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Construir la petición
      final orderRequest = _buildOrderRequest();
      
      Logger.info('Creating order with ${_cartItems.length} products');
      
      // Llamar al use case
      final result = await createOrderNewUseCase.call(orderRequest);

      result.fold(
        (failure) {
          Logger.error('Error creating order: ${failure.message}');
          _status = CartStatus.error;
          _errorMessage = failure.message;
        },
        (order) {
          Logger.info('Order created successfully: ${order.id}');
          _status = CartStatus.success;
          _createdOrder = order;
          _errorMessage = null;
          
          // Limpiar el carrito después de crear la orden exitosamente
          _cartItems.clear();
        },
      );
    } catch (e) {
      Logger.error('Unexpected error creating order: $e');
      _status = CartStatus.error;
      _errorMessage = 'Error inesperado al crear la orden';
    }

    notifyListeners();
  }

  CreateOrderRequestModel _buildOrderRequest() {
    // Convertir items del carrito a productos solicitados (nueva estructura simplificada)
    final requestedProducts = _cartItems.map((item) {
      return RequestedProductModel(
        productId: item.productId,
        requestedQuantity: item.quantity,
        message: item.message,
      );
    }).toList();

    return CreateOrderRequestModel(
      orderType: _orderType,
      tableId: _orderType == 'table' ? _tableNumber.toString() : null,
      peopleCount: _orderType == 'table' ? _peopleCount : 1,
      requestedProducts: requestedProducts,
    );
  }

  // Métodos de conveniencia para el UI
  void increaseProductQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final currentQuantity = _cartItems[index].quantity;
      updateProductQuantity(productId, currentQuantity + 1);
    }
  }

  void decreaseProductQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final currentQuantity = _cartItems[index].quantity;
      updateProductQuantity(productId, currentQuantity - 1);
    }
  }

  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  bool isProductInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }
}