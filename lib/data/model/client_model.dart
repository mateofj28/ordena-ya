import '../../domain/entities/client.dart';


class ClientModel extends Client {
  ClientModel({
    required super.fullName,
    required super.idNumber,
    required super.email,
    required super.phone,
    required super.registrationDate,
    required super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      fullName: json['fullName'],
      idNumber: json['idNumber'],
      email: json['email'],
      phone: json['phone'],
      registrationDate: DateTime.parse(json['registrationDate']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'idNumber': idNumber,
      'email': email,
      'phone': phone,
      'registrationDate': registrationDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      fullName: entity.fullName,
      idNumber: entity.idNumber,
      email: entity.email,
      phone: entity.phone,
      registrationDate: entity.registrationDate,
      updatedAt: entity.updatedAt,
    );
  }

  Client toEntity() => this;
}
