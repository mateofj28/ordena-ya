import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/create_order_repository.dart';

class CreateOrderNewUseCase {
  final CreateOrderRepository repository;

  CreateOrderNewUseCase({required this.repository});

  Future<Either<Failure, OrderResponseEntity>> call(CreateOrderRequestModel orderRequest) async {
    Logger.info('UseCase: Creating new order');
    return await repository.createOrder(orderRequest);
  }
}