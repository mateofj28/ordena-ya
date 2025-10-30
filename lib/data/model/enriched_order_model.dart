// Modelo optimizado para la nueva estructura enriquecida de órdenes
// Solo incluye los campos que realmente se usan en la UI

class EnrichedOrderModel {
  final String id;
  final String orderType;
  final String? tableId;
  final int peopleCount;
  final List<EnrichedOrderProduct> requestedProducts;
  final int itemCount;
  final double total;
  final DateTime createdAt;
  final String status;
  
  // Información enriquecida de mesa (solo campos necesarios para UI)
  final EnrichedTableInfo? tableInfo;
  
  // Información enriquecida de empresa (solo campos necesarios para UI)
  final EnrichedCompanyInfo? companyInfo;
  
  // Información del creador (solo campos necesarios para UI)
  final EnrichedCreatorInfo? createdByInfo;

  EnrichedOrderModel({
    required this.id,
    required this.orderType,
    this.tableId,
    required this.peopleCount,
    required this.requestedProducts,
    required this.itemCount,
    required this.total,
    required this.createdAt,
    required this.status,
    this.tableInfo,
    this.companyInfo,
    this.createdByInfo,
  });

  factory EnrichedOrderModel.fromJson(Map<String, dynamic> json) {
    return EnrichedOrderModel(
      id: json['_id']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? 'table',
      tableId: json['tableId']?.toString(),
      peopleCount: _parseIntSafely(json['peopleCount']) ?? 1,
      requestedProducts: (json['requestedProducts'] as List<dynamic>?)
          ?.map((product) => EnrichedOrderProduct.fromJson(product))
          .toList() ?? [],
      itemCount: _parseIntSafely(json['itemCount']) ?? 0,
      total: _parseDoubleSafely(json['total']) ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'received',
      tableInfo: json['tableInfo'] != null 
          ? EnrichedTableInfo.fromJson(json['tableInfo']) 
          : null,
      companyInfo: json['companyInfo'] != null 
          ? EnrichedCompanyInfo.fromJson(json['companyInfo']) 
          : null,
      createdByInfo: json['createdByInfo'] != null 
          ? EnrichedCreatorInfo.fromJson(json['createdByInfo']) 
          : null,
    );
  }

  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDoubleSafely(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

// Información de mesa enriquecida (solo campos necesarios)
class EnrichedTableInfo {
  final int number;
  final int capacity;
  final String location;
  final String status;

  EnrichedTableInfo({
    required this.number,
    required this.capacity,
    required this.location,
    required this.status,
  });

  factory EnrichedTableInfo.fromJson(Map<String, dynamic> json) {
    return EnrichedTableInfo(
      number: _parseIntSafely(json['number']) ?? 0,
      capacity: _parseIntSafely(json['capacity']) ?? 0,
      location: json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? 'available',
    );
  }

  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

// Información de empresa enriquecida (solo campos necesarios)
class EnrichedCompanyInfo {
  final String name;
  final String businessName;
  final String address;

  EnrichedCompanyInfo({
    required this.name,
    required this.businessName,
    required this.address,
  });

  factory EnrichedCompanyInfo.fromJson(Map<String, dynamic> json) {
    // Manejar address como objeto o string
    String addressText = '';
    if (json['address'] != null) {
      if (json['address'] is String) {
        addressText = json['address'];
      } else if (json['address'] is Map<String, dynamic>) {
        final addr = json['address'] as Map<String, dynamic>;
        addressText = '${addr['street']?.toString() ?? ''}, ${addr['city']?.toString() ?? ''}, ${addr['state']?.toString() ?? ''}';
      }
    }

    return EnrichedCompanyInfo(
      name: json['name']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? json['name']?.toString() ?? '',
      address: addressText,
    );
  }
}

// Información del creador enriquecida (solo campos necesarios)
class EnrichedCreatorInfo {
  final String name;
  final String email;
  final String role;

  EnrichedCreatorInfo({
    required this.name,
    required this.email,
    required this.role,
  });

  factory EnrichedCreatorInfo.fromJson(Map<String, dynamic> json) {
    return EnrichedCreatorInfo(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}

// Producto en orden enriquecida (mantiene estructura existente)
class EnrichedOrderProduct {
  final String productId;
  final EnrichedProductSnapshot productSnapshot;
  final int requestedQuantity;
  final String message;
  final List<EnrichedProductStatus> statusByQuantity;

  EnrichedOrderProduct({
    required this.productId,
    required this.productSnapshot,
    required this.requestedQuantity,
    required this.message,
    required this.statusByQuantity,
  });

  factory EnrichedOrderProduct.fromJson(Map<String, dynamic> json) {
    // Crear snapshot por defecto si no existe
    EnrichedProductSnapshot snapshot;
    if (json['productSnapshot'] != null) {
      snapshot = EnrichedProductSnapshot.fromJson(json['productSnapshot']);
    } else {
      // Crear snapshot básico usando productId como nombre temporal
      snapshot = EnrichedProductSnapshot(
        name: 'Producto ${json['productId']?.toString() ?? 'Desconocido'}',
        price: 0.0,
        category: 'general',
        description: 'Información no disponible',
      );
    }

    return EnrichedOrderProduct(
      productId: json['productId']?.toString() ?? '',
      productSnapshot: snapshot,
      requestedQuantity: _parseIntSafely(json['requestedQuantity']) ?? 0,
      message: json['message']?.toString() ?? '',
      statusByQuantity: (json['statusByQuantity'] as List<dynamic>?)
          ?.map((status) => EnrichedProductStatus.fromJson(status))
          .toList() ?? [],
    );
  }

  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

// Snapshot del producto (solo campos necesarios para UI)
class EnrichedProductSnapshot {
  final String name;
  final double price;
  final String category;
  final String description;

  EnrichedProductSnapshot({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  factory EnrichedProductSnapshot.fromJson(Map<String, dynamic> json) {
    return EnrichedProductSnapshot(
      name: json['name']?.toString() ?? '',
      price: _parseDoubleSafely(json['price']) ?? 0.0,
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  static double? _parseDoubleSafely(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

// Estado por cantidad (mantiene estructura existente)
class EnrichedProductStatus {
  final int index;
  final String status;

  EnrichedProductStatus({
    required this.index,
    required this.status,
  });

  factory EnrichedProductStatus.fromJson(Map<String, dynamic> json) {
    return EnrichedProductStatus(
      index: _parseIntSafely(json['index']) ?? 1,
      status: json['status']?.toString() ?? 'pendiente',
    );
  }

  static int? _parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}