import 'package:ordena_ya/domain/dto/order_item.dart';
import '../../core/network/api_client.dart';


abstract class OrderItemRemoteDataSource {
  Future<void> addItemToOrder(int orderId, OrderItem item);
  Future<void> updateItemInOrder(
    int orderId,
    int itemId,
    OrderItem item,
  );
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final ApiClient apiClient;

  OrderItemRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> addItemToOrder(int orderId, OrderItem item) async {
    final res = await apiClient.post('/orders/$orderId/items', item.toJson());
    if (res['statusCode'] != 200) {
      throw Exception('Error al agregar producto');
    }
  }

  @override
  Future<void> updateItemInOrder(
    int orderId,
    int itemId,
    OrderItem item,
  ) async {
    final res = await apiClient.patch(
      '/orders/$orderId/items/$itemId',
      item.toJson(),
    );
    if (res['statusCode'] != 200) {
      throw Exception('Error al editar el producto');
    }
  }
}
