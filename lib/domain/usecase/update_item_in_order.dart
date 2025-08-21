import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/order_item.dart';
import '../repository/order_item_repository.dart';

class UpdateItemInOrderUseCase {
  final OrderItemRepository repository;

  UpdateItemInOrderUseCase(this.repository);

  Future<Either<Failure, OrderItem>> call(int orderId, int itemId, OrderItem item) {
    return repository.updateItemInOrder(orderId, itemId, item);
  }
}
