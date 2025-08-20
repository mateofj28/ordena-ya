import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/order_item.dart';

abstract class OrderItemRepository {
  // Agregar un producto a la orden
  Future<Either<Failure, OrderItem>> addItemToOrder(String orderId, OrderItem item);

  // Editar un producto que ya está en la orden
  Future<Either<Failure, OrderItem>> updateItemInOrder(String orderId, String itemId, OrderItem item);
}
