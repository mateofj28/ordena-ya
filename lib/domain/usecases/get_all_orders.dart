// domain/usecases/create_order.dart
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetAllOrders {
  final OrderRepository repository;

  GetAllOrders(this.repository);

  Future<List<Order>> call() {
    return repository.getAllOrders();
  }
}
