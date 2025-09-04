import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';


class SetOrderIdUseCase {
  final OrderRepository repository;

  SetOrderIdUseCase(this.repository);

  Future<Either<Failure, void>> call(int orderId) {
    return repository.setOrderId(orderId);
  }
}
