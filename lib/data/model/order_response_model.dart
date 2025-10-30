import 'package:ordena_ya/domain/entity/order_response.dart';

class OrderResponseModel {
  final String id;
  final int mesa;
  final int cantidadPersonas;
  final String tipoPedido;
  final List<ProductoSolicitadoModel> productosSolicitados;
  final int cantidadIps;
  final double total;
  final DateTime fechaCreacion;
  final String estadoGeneral;

  OrderResponseModel({
    required this.id,
    required this.mesa,
    required this.cantidadPersonas,
    required this.tipoPedido,
    required this.productosSolicitados,
    required this.cantidadIps,
    required this.total,
    required this.fechaCreacion,
    required this.estadoGeneral,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    print('🔍 PARSING ORDER RESPONSE:');
    print('  - JSON keys: ${json.keys.toList()}');
    
    // Verificar si es una respuesta de creación (solo tiene message y orderId)
    if (json.containsKey('message') && json.containsKey('orderId') && !json.containsKey('_id')) {
      print('  - Detected: Creation response');
      // Es una respuesta de creación, crear un modelo básico
      return OrderResponseModel(
        id: json['orderId'] ?? '',
        mesa: 0, // Valores por defecto, se actualizarán cuando se obtenga la orden completa
        cantidadPersonas: 0,
        tipoPedido: '',
        productosSolicitados: [],
        cantidadIps: 0,
        total: 0.0,
        fechaCreacion: DateTime.now(),
        estadoGeneral: 'received',
      );
    }
    
    print('  - Detected: Full order response');
    
    // Es una respuesta completa (listado de órdenes)
    List<dynamic>? productsList = json['requestedProducts'] ?? json['productosSolicitados'];
    
    print('  - Products list: ${productsList?.length ?? 0} items');
    if (productsList != null && productsList.isNotEmpty) {
      print('  - First product: ${productsList.first}');
      
      // DETECTAR SI ES RESPUESTA DE BACKEND INCOMPLETA (sin productSnapshot)
      final firstProduct = productsList.first as Map<String, dynamic>;
      final hasProductSnapshot = firstProduct.containsKey('productSnapshot');
      print('  - Has productSnapshot: $hasProductSnapshot');
      
      if (!hasProductSnapshot) {
        print('  ⚠️  WARNING: Backend returned incomplete data (no productSnapshot)');
        print('  ⚠️  This is a BACKEND BUG in the UPDATE endpoint');
      }
    }
    
    final orderId = json['_id'] ?? json['id'] ?? json['orderId'] ?? '';
    
    // DETECTAR MESA DESDE tableInfo SI ESTÁ DISPONIBLE
    int mesa = json['table'] ?? json['mesa'] ?? 0;
    if (mesa == 0 && json['tableInfo'] != null) {
      final tableInfo = json['tableInfo'] as Map<String, dynamic>;
      mesa = tableInfo['number'] ?? 0;
      print('  - Mesa extracted from tableInfo: $mesa');
    }
    
    final peopleCount = json['peopleCount'] ?? json['cantidadPersonas'] ?? 0;
    final orderType = json['orderType'] ?? json['tipoPedido'] ?? '';
    final total = (json['total'] ?? 0).toDouble();
    
    print('  - Parsed values:');
    print('    * ID: $orderId');
    print('    * Mesa: $mesa');
    print('    * People: $peopleCount');
    print('    * Type: $orderType');
    print('    * Total: $total');
    
    return OrderResponseModel(
      id: orderId,
      mesa: mesa,
      cantidadPersonas: peopleCount,
      tipoPedido: orderType,
      productosSolicitados: productsList != null
          ? productsList.map((item) => ProductoSolicitadoModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      cantidadIps: json['itemCount'] ?? json['cantidadIps'] ?? 0,
      total: total,
      fechaCreacion: DateTime.tryParse(json['createdAt'] ?? json['fechaCreacion'] ?? '') ?? DateTime.now(),
      estadoGeneral: json['status'] ?? json['estadoGeneral'] ?? _calculateGeneralStatus(productsList),
    );
  }

  static String _calculateGeneralStatus(List<dynamic>? products) {
    if (products == null || products.isEmpty) return 'received';
    
    // Obtener todos los estados de todos los productos
    List<String> allStatuses = [];
    for (var product in products) {
      var statusByQuantity = product['statusByQuantity'] as List<dynamic>?;
      if (statusByQuantity != null) {
        for (var status in statusByQuantity) {
          allStatuses.add(status['status'] ?? 'pendiente');
        }
      }
    }
    
    if (allStatuses.isEmpty) return 'received';
    
    // Si todos están entregados
    if (allStatuses.every((status) => status == 'entregado')) {
      return 'completed';
    }
    
    // Si hay alguno en preparación
    if (allStatuses.any((status) => status == 'en preparación')) {
      return 'in_progress';
    }
    
    // Si hay alguno listo para entregar
    if (allStatuses.any((status) => status == 'listo para entregar')) {
      return 'ready';
    }
    
    // Por defecto received
    return 'received';
  }

  Map<String, dynamic> toJson() {
    return {
      'orderType': tipoPedido,
      'table': mesa,
      'peopleCount': cantidadPersonas,
      'requestedProducts': productosSolicitados.map((item) => item.toJson()).toList(),
      'itemCount': cantidadIps,
      'total': total,
    };
  }

  OrderResponseEntity toEntity() {
    return OrderResponseEntity(
      id: id,
      mesa: mesa,
      cantidadPersonas: cantidadPersonas,
      tipoPedido: tipoPedido,
      productosSolicitados: productosSolicitados.map((item) => item.toEntity()).toList(),
      cantidadIps: cantidadIps,
      total: total,
      fechaCreacion: fechaCreacion,
      estadoGeneral: estadoGeneral,
    );
  }
}

class ProductoSolicitadoModel {
  final String productId;
  final String nombreProducto;
  final double price;
  final int cantidadSolicitada;
  final String mensaje;
  final List<EstadoPorCantidadModel> estadosPorCantidad;

  ProductoSolicitadoModel({
    required this.productId,
    required this.nombreProducto,
    required this.price,
    required this.cantidadSolicitada,
    required this.mensaje,
    required this.estadosPorCantidad,
  });

  factory ProductoSolicitadoModel.fromJson(Map<String, dynamic> json) {
    print('    🔍 PARSING PRODUCT:');
    print('      - JSON: $json');
    
    // Obtener la lista de estados de manera segura
    List<dynamic>? statusList = json['statusByQuantity'] ?? json['estadosPorCantidad'];
    
    final productId = json['productId'] ?? '';
    
    // MANEJAR FALTA DE productSnapshot (BUG DEL BACKEND)
    String productName = '';
    double price = 0.0;
    
    if (json.containsKey('productSnapshot')) {
      // Caso normal: hay productSnapshot
      final snapshot = json['productSnapshot'] as Map<String, dynamic>;
      productName = snapshot['name'] ?? '';
      price = (snapshot['price'] ?? 0).toDouble();
      print('      - Using productSnapshot data');
    } else {
      // FALLBACK: Backend no envió productSnapshot (BUG)
      productName = json['productName'] ?? json['nombreProducto'] ?? 'Producto ${productId.substring(0, 8)}';
      price = (json['price'] ?? 0).toDouble();
      print('      ⚠️  FALLBACK: No productSnapshot, using direct fields');
    }
    
    final quantity = json['requestedQuantity'] ?? json['cantidadSolicitada'] ?? 0;
    final message = json['message'] ?? json['mensaje'] ?? '';
    
    // Si no hay statusByQuantity, crear estados por defecto
    if (statusList == null || statusList.isEmpty) {
      statusList = [];
      for (int i = 0; i < quantity; i++) {
        statusList.add({'status': 'pendiente'});
      }
      print('      ⚠️  FALLBACK: Created default status list');
    }
    
    print('      - Parsed values:');
    print('        * ID: $productId');
    print('        * Name: $productName');
    print('        * Price: $price');
    print('        * Quantity: $quantity');
    print('        * Message: $message');
    print('        * Status list: ${statusList.length} items');
    
    return ProductoSolicitadoModel(
      productId: productId,
      nombreProducto: productName,
      price: price,
      cantidadSolicitada: quantity,
      mensaje: message,
      estadosPorCantidad: statusList
          .map((item) => EstadoPorCantidadModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': nombreProducto,
      'price': price,
      'requestedQuantity': cantidadSolicitada,
      'message': mensaje,
      'statusByQuantity': estadosPorCantidad.map((item) => item.toJson()).toList(),
    };
  }

  ProductoSolicitadoEntity toEntity() {
    return ProductoSolicitadoEntity(
      productId: productId,
      nombreProducto: nombreProducto,
      price: price,
      cantidadSolicitada: cantidadSolicitada,
      mensaje: mensaje,
      estadosPorCantidad: estadosPorCantidad.map((item) => item.toEntity()).toList(),
    );
  }
}

class EstadoPorCantidadModel {
  final String estado;

  EstadoPorCantidadModel({
    required this.estado,
  });

  factory EstadoPorCantidadModel.fromJson(Map<String, dynamic> json) {
    return EstadoPorCantidadModel(
      estado: json['status'] ?? json['estado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': estado,
    };
  }

  EstadoPorCantidadEntity toEntity() {
    return EstadoPorCantidadEntity(
      estado: estado,
    );
  }
}