import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderResponseEntity>>> getAllOrders();
  Future<Either<Failure, OrderResponseEntity>> getOrderById(String id);
}