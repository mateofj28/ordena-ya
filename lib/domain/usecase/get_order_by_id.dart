import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/orders_repository.dart';

class GetOrderByIdUseCase {
  final OrdersRepository repository;

  GetOrderByIdUseCase({required this.repository});

  Future<Either<Failure, OrderResponseEntity>> call(String id) async {
    Logger.info('UseCase: Getting order by ID: $id');
    return await repository.getOrderById(id);
  }
}