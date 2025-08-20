import '../../core/network/api_client.dart';
import '../model/order_item_model.dart';

abstract class OrderItemRemoteDataSource {
  Future<OrderItemModel> addItemToOrder(String orderId, OrderItemModel item);
  Future<OrderItemModel> updateItemInOrder(String orderId, String itemId, OrderItemModel item);
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final ApiClient apiClient;

  OrderItemRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<OrderItemModel> addItemToOrder(String orderId, OrderItemModel item) async {
    final res = await apiClient.post('/orders/$orderId/items', item.toJson());
    return OrderItemModel.fromJson(res);
  }

  @override
  Future<OrderItemModel> updateItemInOrder(String orderId, String itemId, OrderItemModel item) async {
    final res = await apiClient.patch('/orders/$orderId/items/$itemId', item.toJson());
    return OrderItemModel.fromJson(res);
  }
}
