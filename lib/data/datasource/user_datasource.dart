import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import '../../core/network/api_client.dart';
import 'package:ordena_ya/data/model/user_model.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(Credentials credentials);
  Future<UserModel> registerUser(RegisterUserModel userInfo);
  Future<ClientModel> registerClient(ClientModel client);
}

class UserRemoteDataSourceImple implements UserRemoteDataSource {
  final ApiClient apiClient;
  
  UserRemoteDataSourceImple({
    required this.apiClient,
  });

  @override
  Future<UserModel> login(Credentials credentials) async {
    final response = await apiClient.post('/auth/login', credentials.toJson());
    return UserModel.fromJson(response);
  }
  
  @override
  Future<UserModel> registerUser(RegisterUserModel userInfo) async {
    final response = await apiClient.post('/auth/register', userInfo.toJson());
    return UserModel.fromJson(response);
  }
  
  @override
  Future<ClientModel> registerClient(ClientModel client) async {
    final response = await apiClient.post('/clients', client.toJson());
    return ClientModel.fromJson(response);
  }


}
