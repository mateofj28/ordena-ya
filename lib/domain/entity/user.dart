class User {
  final int id;
  final String? token;
  final int tenantId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.tenantId,
    required this.token,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
  });
}
