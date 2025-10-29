import 'package:ordena_ya/domain/entity/restaurant_table.dart';

class TableModel extends RestaurantTable {
  TableModel({
    required super.id,
    required super.tenantId,
    required super.tableNumber,
    required super.capacity,
    required super.status,
    required super.location,
  });

  /// Crear TableModel desde JSON
  factory TableModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '0'; // Convertir a string
    final tenantId = json['tenant_id'] ?? 0;
    final tableNumber = json['number'] ?? '';
    final capacityRaw = json['capacity'] ?? 0;
    final int capacity =
        capacityRaw is int
            ? capacityRaw
            : int.tryParse(capacityRaw.toString()) ?? 0;
    final location = json['location'] ?? '';
    final status = json['status'] ?? '';

    return TableModel(
      id: id,
      tenantId: tenantId,
      tableNumber: tableNumber,
      capacity: capacity,
      location: location,
      status: status,
    );
  }

  RestaurantTable toEntity() {
    return RestaurantTable(
      id: id,
      tenantId: tenantId,
      tableNumber: tableNumber,
      capacity: capacity,
      location: location,
      status: status,
    );
  }
}
