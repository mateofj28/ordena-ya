import '../../core/network/api_client.dart';
import '../model/order_item_model.dart';

abstract class OrderItemRemoteDataSource {
  Future<OrderItemModel> addItemToOrder(int orderId, OrderItemModel item);
  Future<OrderItemModel> updateItemInOrder(int orderId, int itemId, OrderItemModel item);
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final ApiClient apiClient;

  OrderItemRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<OrderItemModel> addItemToOrder(int orderId, OrderItemModel item) async {
    final res = await apiClient.post('/orders/$orderId/items', item.toJson());
    return OrderItemModel.fromJson(res['item']);
  }

  @override
  Future<OrderItemModel> updateItemInOrder(int orderId, int itemId, OrderItemModel item) async {
    final res = await apiClient.patch('/orders/$orderId/items/$itemId', item.toJson());
    return OrderItemModel.fromJson(res);
  }
}
