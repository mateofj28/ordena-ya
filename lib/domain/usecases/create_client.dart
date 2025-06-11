// domain/usecases/create_order.dart
import 'package:ordena_ya/domain/entities/client.dart';
import 'package:ordena_ya/domain/repositories/client_repository.dart';


class CreateClient {
  final ClientRepository repository;

  CreateClient(this.repository);

  Future<void> call(Client client) {
    return repository.createClient(client);
  }
}
