import 'package:ordena_ya/domain/entity/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.tenantId,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.role,
    required super.createdAt,
    super.token,
  });

  /// Crear un UserModel desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> user = json['user'];

    return UserModel(
      id: user['id'] ?? 0,
      tenantId: user['tenant_id'] ?? 0,
      username: user['username'] ?? '',
      email: user['email'] ?? '',
      token: json['token'],
      firstName: user['first_name'] ?? '',
      lastName: user['last_name'] ?? '',
      role: user['role'] ?? '',
      createdAt: DateTime.tryParse(user['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convertir UserModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convertir UserModel a User (entidad pura)
  User toEntity() {
    return User(
      id: id,
      tenantId: tenantId,
      token: token,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      createdAt: createdAt,
    );
  }
}
