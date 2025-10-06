import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/dto/order_item.dart';
import '../repository/order_item_repository.dart';

class AddItemToOrderUseCase {
  final OrderItemRepository repository;

  AddItemToOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(String orderId, OrderItem item) {
    return repository.addItemToOrder(orderId, item);
  }
}
