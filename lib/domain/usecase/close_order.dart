import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/create_order_repository.dart';

class CloseOrderUseCase {
  final CreateOrderRepository repository;

  CloseOrderUseCase({required this.repository});

  Future<Either<Failure, OrderResponseEntity>> call(String orderId) async {
    Logger.info('UseCase: Closing order: $orderId');
    return await repository.closeOrder(orderId);
  }
}