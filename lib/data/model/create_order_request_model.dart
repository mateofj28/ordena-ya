class CreateOrderRequestModel {
  final String orderType;
  final String? tableId; // Cambio: ahora es String (ID de la mesa) y opcional
  final int peopleCount;
  final List<RequestedProductModel> requestedProducts;
  // Eliminados: itemCount y total (se calculan automáticamente en el backend)

  CreateOrderRequestModel({
    required this.orderType,
    this.tableId, // Opcional para delivery/takeout
    required this.peopleCount,
    required this.requestedProducts,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'orderType': orderType,
      'peopleCount': peopleCount,
      'requestedProducts': requestedProducts.map((product) => product.toJson()).toList(),
    };
    
    // Solo agregar tableId si es una orden de mesa
    if (tableId != null && orderType == 'table') {
      json['tableId'] = tableId!;
    }
    
    return json;
  }
}

class RequestedProductModel {
  final String productId;
  final int requestedQuantity;
  final String message;
  // Eliminados: productName, price, statusByQuantity (se generan automáticamente en el backend)

  RequestedProductModel({
    required this.productId,
    required this.requestedQuantity,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'requestedQuantity': requestedQuantity,
      'message': message,
    };
  }
}

class ProductStatusModel {
  final String status;

  ProductStatusModel({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}