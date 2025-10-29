// Modelos para clientes del nuevo servidor

class CreateCustomerRequestModel {
  final String fullName;
  final String deliveryAddress;
  final String city;
  final String state;
  final String phoneNumber;
  final String email;

  CreateCustomerRequestModel({
    required this.fullName,
    required this.deliveryAddress,
    required this.city,
    required this.state,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'deliveryAddress': deliveryAddress,
      'city': city,
      'state': state,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}

class CustomerResponseModel {
  final String id;
  final String fullName;
  final String deliveryAddress;
  final String city;
  final String state;
  final String phoneNumber;
  final String email;
  final String formattedPhone;
  final bool isActive;
  final int totalOrders;

  CustomerResponseModel({
    required this.id,
    required this.fullName,
    required this.deliveryAddress,
    required this.city,
    required this.state,
    required this.phoneNumber,
    required this.email,
    required this.formattedPhone,
    required this.isActive,
    required this.totalOrders,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      formattedPhone: json['formattedPhone'] ?? '',
      isActive: json['isActive'] ?? true,
      totalOrders: json['totalOrders'] ?? 0,
    );
  }
}