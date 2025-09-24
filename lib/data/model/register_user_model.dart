import 'package:ordena_ya/domain/dto/register_user_req.dart';

class RegisterUserModel extends RegisterUserRequest {
  RegisterUserModel({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.tenantId,
    required super.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "tenant_id": tenantId,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "role": role,
    };
  }
}
