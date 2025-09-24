import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/domain/entity/user.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterUserModel userInfo) {
    return repository.registerUser(userInfo);
  }
}
