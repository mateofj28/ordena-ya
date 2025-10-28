import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/core/token/token_storage.dart';
import 'package:ordena_ya/data/datasource/user_datasource.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/domain/dto/register_clint_req.dart';
import 'package:ordena_ya/domain/entity/user.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';
import 'package:ordena_ya/presentation/widgets/register_client_modal.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource datasource;
  final TokenStorage tokenStorage;

  UserRepositoryImpl(this.datasource, this.tokenStorage);

  @override
  Future<Either<Failure, User>> login(Credentials credentials) async {
    try {
      final user = await datasource.login(credentials);
      await tokenStorage.saveToken(user.token!);
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> registerUser(RegisterUserModel userInfo) async {
    try {
      final user = await datasource.registerUser(userInfo);
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterClientRequest>> registerClient(ClientModel clientRequest) async {
    try {
      final client = await datasource.registerClient(clientRequest);
      return Right(client.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }    
  }
}
