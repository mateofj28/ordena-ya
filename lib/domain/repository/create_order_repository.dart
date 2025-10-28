import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';

abstract class CreateOrderRepository {
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderRequestModel orderRequest);
  Future<Either<Failure, OrderResponseEntity>> updateOrder(String orderId, CreateOrderRequestModel orderRequest);
}