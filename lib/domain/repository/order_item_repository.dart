import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/dto/order_item.dart';

abstract class OrderItemRepository {
  // Agregar un producto a la orden
  Future<Either<Failure, void>> addItemToOrder(int orderId, OrderItem item);

  // Editar un producto que ya está en la orden
  Future<Either<Failure, void>> updateItemInOrder(int orderId, int itemId, OrderItem item);
}
