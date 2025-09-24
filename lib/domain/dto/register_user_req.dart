class RegisterUserRequest {
  final int tenantId;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  RegisterUserRequest({
    required this.tenantId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });
}
