import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/domain/dto/register_clint_req.dart';
import 'package:ordena_ya/domain/entity/user.dart';


class Credentials {
  String email;
  String password;

  Credentials({ 
    required this.email, 
    required this.password,
  });

  /// Convertir Credentials a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}


abstract class UserRepository {
  Future<Either<Failure, User>> login(Credentials credentials);
  Future<Either<Failure, User>> registerUser(RegisterUserModel userInfo);
  Future<Either<Failure, RegisterClientRequest>> registerClient(ClientModel clientRequest);
}


