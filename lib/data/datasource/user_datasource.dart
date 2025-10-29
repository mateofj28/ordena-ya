import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/data/model/user_model.dart';
import 'package:ordena_ya/data/model/auth_models.dart';
import 'package:ordena_ya/data/model/customer_models.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';
import 'package:ordena_ya/core/token/token_storage.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(Credentials credentials);
  Future<UserModel> registerUser(RegisterUserModel userInfo);
  Future<ClientModel> registerClient(ClientModel client);
}

class UserRemoteDataSourceImple implements UserRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;
  
  UserRemoteDataSourceImple({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<UserModel> login(Credentials credentials) async {
    try {
      final url = ApiConfig.authLoginEndpoint;
      final loginRequest = LoginRequestModel(
        email: credentials.email,
        password: credentials.password,
      );
      final body = json.encode(loginRequest.toJson());
      
      Logger.info('Login request to: $url');
      Logger.info('Request body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          Logger.error('Login timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Login response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final authResponse = AuthResponseModel.fromJson(json);
        
        // Convertir AuthResponseModel a UserModel (modelo existente)
        final userModel = UserModel(
          id: int.tryParse(authResponse.user.id) ?? 0,
          tenantId: 1, // ID del tenant por defecto
          username: authResponse.user.email, // Usar email como username
          email: authResponse.user.email,
          firstName: authResponse.user.name.split(' ').first,
          lastName: authResponse.user.name.split(' ').length > 1 
              ? authResponse.user.name.split(' ').skip(1).join(' ') 
              : '',
          role: authResponse.user.role,
          createdAt: DateTime.now(),
          token: authResponse.token,
        );

        Logger.info('Successfully logged in user: ${userModel.email}');
        return userModel;
      } else {
        Logger.error('Failed to login: ${response.statusCode}');
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error during login: $e');
      throw Exception('Error during login: $e');
    }
  }
  
  @override
  Future<UserModel> registerUser(RegisterUserModel userInfo) async {
    try {
      final url = ApiConfig.authRegisterEndpoint;
      final registerRequest = RegisterRequestModel(
        name: '${userInfo.firstName} ${userInfo.lastName}',
        email: userInfo.email,
        password: userInfo.password,
        role: userInfo.role,
        companyId: '60d5ecb74b24a1234567890a', // ID por defecto
      );
      final body = json.encode(registerRequest.toJson());
      
      Logger.info('Register request to: $url');
      Logger.info('Request body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          Logger.error('Register timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Register response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final authResponse = AuthResponseModel.fromJson(json);
        
        // Convertir AuthResponseModel a UserModel (modelo existente)
        final userModel = UserModel(
          id: int.tryParse(authResponse.user.id) ?? 0,
          tenantId: 1, // ID del tenant por defecto
          username: authResponse.user.email, // Usar email como username
          email: authResponse.user.email,
          firstName: authResponse.user.name.split(' ').first,
          lastName: authResponse.user.name.split(' ').length > 1 
              ? authResponse.user.name.split(' ').skip(1).join(' ') 
              : '',
          role: authResponse.user.role,
          createdAt: DateTime.now(),
          token: authResponse.token,
        );

        Logger.info('Successfully registered user: ${userModel.email}');
        return userModel;
      } else {
        Logger.error('Failed to register: ${response.statusCode}');
        throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error during registration: $e');
      throw Exception('Error during registration: $e');
    }
  }
  
  @override
  Future<ClientModel> registerClient(ClientModel clientModel) async {
    try {
      final url = ApiConfig.customersEndpoint;
      final customerRequest = CreateCustomerRequestModel(
        fullName: clientModel.fullName ?? '',
        deliveryAddress: clientModel.deliveryAddress ?? '',
        city: clientModel.city ?? '',
        state: '', // No disponible en ClientModel
        phoneNumber: clientModel.phoneNumber ?? '',
        email: clientModel.email ?? '',
      );
      final body = json.encode(customerRequest.toJson());
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Create customer request to: $url');
      Logger.info('Request body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          Logger.error('Create customer timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Create customer response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final customerResponse = CustomerResponseModel.fromJson(json);
        
        // Convertir CustomerResponseModel a ClientModel (modelo existente)
        final resultClientModel = ClientModel(
          id: customerResponse.id,
          fullName: customerResponse.fullName,
          email: customerResponse.email,
          deliveryAddress: customerResponse.deliveryAddress,
          city: customerResponse.city,
          phoneNumber: customerResponse.phoneNumber,
        );

        Logger.info('Successfully created customer: ${resultClientModel.fullName}');
        return resultClientModel;
      } else {
        Logger.error('Failed to create customer: ${response.statusCode}');
        throw Exception('Failed to create customer: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error creating customer: $e');
      throw Exception('Error creating customer: $e');
    }
  }
}
