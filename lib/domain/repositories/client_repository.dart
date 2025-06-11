// domain/repositories/order_repository.dart
import 'package:ordena_ya/domain/entities/client.dart';

abstract class ClientRepository {
  Future<void> createClient(Client client);
  Future<List<Client>> getAllClients();
}
