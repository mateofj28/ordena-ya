// domain/usecases/create_order.dart
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetAllOrders {
  final ClientRepository repository;

  GetAllOrders(this.repository);

  Future<List<Order>> call() {
    return repository.getAllOrders();
  }
}
