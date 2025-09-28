import 'package:ordena_ya/domain/dto/register_clint_req.dart';

class ClientModel extends RegisterClientRequest {
  ClientModel({
    super.id,
    super.fullName,
    super.deliveryAddress,
    super.city,
    super.phoneNumber,
    super.email,
  });
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'deliveryAddress': deliveryAddress,
      'city': city,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(id: json['clientId']);
  }

  RegisterClientRequest toEntity() {
    return RegisterClientRequest(
      id: id,
    );
  }
}
