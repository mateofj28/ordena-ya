// Modelos para mesas del nuevo servidor

class TableResponseModel {
  final List<TableDataModel> tables;
  final TableStatsModel stats;

  TableResponseModel({
    required this.tables,
    required this.stats,
  });

  factory TableResponseModel.fromJson(Map<String, dynamic> json) {
    return TableResponseModel(
      tables: (json['tables'] as List<dynamic>?)
          ?.map((table) => TableDataModel.fromJson(table))
          .toList() ?? [],
      stats: TableStatsModel.fromJson(json['stats'] ?? {}),
    );
  }
}

class TableDataModel {
  final String id;
  final int number;
  final int capacity;
  final String status;
  final String location;
  final bool isActive;

  TableDataModel({
    required this.id,
    required this.number,
    required this.capacity,
    required this.status,
    required this.location,
    required this.isActive,
  });

  factory TableDataModel.fromJson(Map<String, dynamic> json) {
    return TableDataModel(
      id: json['_id'] ?? '',
      number: json['number'] ?? 0,
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'available',
      location: json['location'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}

class TableStatsModel {
  final int available;
  final int occupied;
  final int reserved;

  TableStatsModel({
    required this.available,
    required this.occupied,
    required this.reserved,
  });

  factory TableStatsModel.fromJson(Map<String, dynamic> json) {
    return TableStatsModel(
      available: json['available'] ?? 0,
      occupied: json['occupied'] ?? 0,
      reserved: json['reserved'] ?? 0,
    );
  }
}