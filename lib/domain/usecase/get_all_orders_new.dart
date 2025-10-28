import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/orders_repository.dart';

class GetAllOrdersNewUseCase {
  final OrdersRepository repository;

  GetAllOrdersNewUseCase({required this.repository});

  Future<Either<Failure, List<OrderResponseEntity>>> call() async {
    Logger.info('UseCase: Getting all orders');
    return await repository.getAllOrders();
  }
}