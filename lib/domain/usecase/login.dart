import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/entity/user.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(Credentials credentials) {
    return repository.login(credentials);
  }
}
