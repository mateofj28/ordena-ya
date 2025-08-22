import 'package:ordena_ya/data/model/order_model.dart';
import '../../core/network/api_client.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> fetchOrders();
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await apiClient.post('/orders', order.toJson());
    return OrderModel.fromJson(response['order']);
  }

  @override
  Future<List<OrderModel>> fetchOrders() async {
    final jsonList = await apiClient.get('/orders');
    final List<dynamic> ordersJson = jsonList['orders'];
    final orders =
        ordersJson.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
    final today = DateTime.now();
    final filtered =
        orders.where((OrderModel order) {
          final createdAt = order.createdAt;
          return createdAt.year == today.year &&
              createdAt.month == today.month &&
              createdAt.day == today.day;
        }).toList();

    return filtered;
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
}
