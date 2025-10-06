import 'package:ordena_ya/data/model/order_model.dart';
import 'package:ordena_ya/domain/dto/register_order_req.dart';
import '../../core/network/api_client.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> fetchOrders();
  Future<OrderModel> createOrder(CreateOrderReq order);
  Future<OrderModel> updateOrder(OrderModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder(CreateOrderReq order) async {
    final response = await apiClient.post('/orders', order.toJson());
    return OrderModel.fromJson(response);
  }

  @override
  Future<List<OrderModel>> fetchOrders() async {
    final jsonList = await apiClient.get('/orders');
    final List<dynamic> ordersJson = jsonList['orders'];
    final orders =
        ordersJson.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
    

    return orders;
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
}
