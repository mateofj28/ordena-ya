import '../../domain/entity/restaurant_table.dart';

class RestaurantTableModel extends RestaurantTable {
  RestaurantTableModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.capacity,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  // Desde JSON
  factory RestaurantTableModel.fromJson(Map<String, dynamic> json) {
    return RestaurantTableModel(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      name: json['name'],
      capacity: json['capacity'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // A JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'capacity': capacity,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convierte de entidad a modelo
  factory RestaurantTableModel.fromEntity(RestaurantTable entity) {
    return RestaurantTableModel(
      id: entity.id,
      restaurantId: entity.restaurantId,
      name: entity.name,
      capacity: entity.capacity,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convierte de modelo a entidad
  RestaurantTable toEntity() {
    return RestaurantTable(
      id: id,
      restaurantId: restaurantId,
      name: name,
      capacity: capacity,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
