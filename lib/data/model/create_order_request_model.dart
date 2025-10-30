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
  final ProductSnapshotModel? productSnapshot; // NUEVO: información del producto
  final List<ProductStatusModel>? statusByQuantity; // NUEVO: estados por cantidad

  RequestedProductModel({
    required this.productId,
    required this.requestedQuantity,
    required this.message,
    this.productSnapshot,
    this.statusByQuantity,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'productId': productId,
      'requestedQuantity': requestedQuantity,
      'message': message,
    };
    
    // Incluir productSnapshot si está disponible
    if (productSnapshot != null) {
      json['productSnapshot'] = productSnapshot!.toJson();
    }
    
    // Incluir statusByQuantity si está disponible
    if (statusByQuantity != null) {
      json['statusByQuantity'] = statusByQuantity!.map((status) => status.toJson()).toList();
    }
    
    return json;
  }
}

// NUEVO: Modelo para snapshot del producto
class ProductSnapshotModel {
  final String name;
  final double price;
  final String category;
  final String description;

  ProductSnapshotModel({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
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