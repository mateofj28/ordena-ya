import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../repository/order_item_repository.dart';

class DeleteItemToOrderUseCase {
  final OrderItemRepository repository;

  DeleteItemToOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(String orderId, String productId) {
    return repository.deleteItemToOrder(orderId, productId);
  }
}
