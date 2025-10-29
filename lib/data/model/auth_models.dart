// Modelos para autenticación

class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String companyId;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'companyId': companyId,
    };
  }
}

class AuthResponseModel {
  final String message;
  final UserDataModel user;
  final String token;

  AuthResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] ?? '',
      user: UserDataModel.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}

class UserDataModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}