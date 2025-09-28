import 'package:flutter/material.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/domain/dto/register_clint_req.dart';
import 'package:ordena_ya/domain/entity/user.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';
import 'package:ordena_ya/domain/usecase/create_client.dart';
import 'package:ordena_ya/domain/usecase/create_user.dart';
import 'package:ordena_ya/domain/usecase/login.dart';

class UserProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final CreateUserUseCase registerUserUseCase;
  final CreateClient registerClientUseCase;

  User? _user;
  RegisterClientRequest? _currentClient;
  User? get user => _user;
  RegisterClientRequest? get currentClient => _currentClient;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  UserProvider({required this.loginUseCase, required this.registerUserUseCase, required this.registerClientUseCase});

  Future<void> login(Credentials credentials) async {
    _setLoading(true);
    final result = await loginUseCase(credentials);
    result.fold(
      (failure) => setError(failure.message),
      (user) => _setUser(user),
    );
    _setLoading(false);
  }

  Future<void> register(RegisterUserModel request) async {
    _setLoading(true);
    final result = await registerUserUseCase(request);
    result.fold(
      (failure) => setError(failure.message),
      (user) => _setUser(user),
    );
    _setLoading(false);
  }

  Future<void> registerClient(ClientModel clientRequest) async {
    _setLoading(true);
    final result = await registerClientUseCase(clientRequest);
    result.fold(
      (failure) => setError(failure.message),
      (client) => _setClient(client),
    );
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setUser(User user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  void _setClient(RegisterClientRequest client) {
    _currentClient = client;
    _error = null;
    notifyListeners();
  }

  void setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
