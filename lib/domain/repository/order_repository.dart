// domain/repositories/order_repository.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, List<Order>>> getAllOrders();
}
