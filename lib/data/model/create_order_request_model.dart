class CreateOrderRequestModel {
  final String orderType;
  final int table;
  final int peopleCount;
  final List<RequestedProductModel> requestedProducts;
  final int itemCount;
  final double total;

  CreateOrderRequestModel({
    required this.orderType,
    required this.table,
    required this.peopleCount,
    required this.requestedProducts,
    required this.itemCount,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'table': table,
      'peopleCount': peopleCount,
      'requestedProducts': requestedProducts.map((product) => product.toJson()).toList(),
      'itemCount': itemCount,
      'total': total,
    };
  }
}

class RequestedProductModel {
  final String productId;
  final String productName;
  final double price;
  final int requestedQuantity;
  final String message;
  final List<ProductStatusModel> statusByQuantity;

  RequestedProductModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.requestedQuantity,
    required this.message,
    required this.statusByQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'requestedQuantity': requestedQuantity,
      'message': message,
      'statusByQuantity': statusByQuantity.map((status) => status.toJson()).toList(),
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