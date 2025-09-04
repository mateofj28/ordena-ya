import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';


class GetOrderIdUseCase {
  final OrderRepository repository;

  GetOrderIdUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getOrderId();
  }
}
