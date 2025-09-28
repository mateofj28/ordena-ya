// domain/usecases/create_order.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/domain/dto/register_clint_req.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';

class CreateClient {
  final UserRepository repository;

  CreateClient(this.repository);

  Future<Either<Failure, RegisterClientRequest>> call(ClientModel clientRequest) {
    return repository.registerClient(clientRequest);
  }
}
