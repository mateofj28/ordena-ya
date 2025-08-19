// domain/usecases/create_order.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';

import '../entity/order.dart';
import '../repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call() {
    return repository.getAllOrders();
  }
}
