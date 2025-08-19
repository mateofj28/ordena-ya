// domain/repositories/order_repository.dart
import 'package:ordena_ya/domain/entity/client.dart';

abstract class ClientRepository {
  Future<void> createClient(Client client);
  Future<List<Client>> getAllClients();
}

// asi esta bien pero falta el either
