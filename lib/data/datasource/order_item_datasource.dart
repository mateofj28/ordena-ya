import 'package:ordena_ya/domain/dto/order_item.dart';
import '../../core/network/api_client.dart';


abstract class OrderItemRemoteDataSource {
  Future<void> addItemToOrder(String orderId, OrderItem item);
  Future<void> updateItemInOrder(
    String orderId,
    int itemId,
    OrderItem item,
  );
  Future<void> deleteItemToOrder(String orderId, String productId);
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final ApiClient apiClient;

  OrderItemRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> addItemToOrder(String orderId, OrderItem item) async {
    await apiClient.post('/orders/$orderId/items', item.toJson());    
  }

  @override
  Future<void> updateItemInOrder(
    String orderId,
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
  
  @override
  Future<void> deleteItemToOrder(String orderId, String productId) async {
    await apiClient.delete('/orders/$orderId/items/$productId');    
  }
}
