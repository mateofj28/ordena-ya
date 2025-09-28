import 'package:ordena_ya/domain/dto/select_table_req.dart';

class SelectTableModel extends SelectTableRequest {
  SelectTableModel({
    required super.number,
    required super.capacity,
    required super.location,
    required super.status,
  });
  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "capacity": capacity,
      "location": location,
      "status": status,
    };
  }
}
