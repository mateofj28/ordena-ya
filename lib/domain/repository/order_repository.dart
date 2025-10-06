// domain/repositories/order_repository.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/dto/register_order_req.dart';
import '../entity/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(CreateOrderReq order);
  Future<Either<Failure, List<Order>>> getAllOrders();
}
