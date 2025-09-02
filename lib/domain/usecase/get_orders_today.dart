// domain/usecases/create_order.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';

import '../entity/order.dart';
import '../repository/order_repository.dart';

class GetOrdersTodayUseCase {
  final OrderRepository repository;

  GetOrdersTodayUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call(String date) {
    return repository.getAllOrdersToday(date);
  }
}
