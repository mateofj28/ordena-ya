import 'package:ordena_ya/domain/entity/unit.dart';

class UnitModel extends Unit {
  UnitModel({
    required super.id,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UnitModel.fromEntity(Unit unit) {
    return UnitModel(
      id: unit.id,
      status: unit.status,
      createdAt: unit.createdAt,
      updatedAt: unit.updatedAt,
    );
  }
}
