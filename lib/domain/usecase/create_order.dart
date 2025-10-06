// domain/usecases/create_order.dart
import 'package:ordena_ya/domain/dto/register_order_req.dart';

import '../../core/model/either.dart';
import '../../core/model/failure.dart';
import '../entity/order.dart';
import '../repository/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, Order>> call(CreateOrderReq order) {
    return repository.createOrder(order);
  }
}
