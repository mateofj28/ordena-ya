import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';
import 'package:ordena_ya/data/model/order_response_model.dart';
import 'package:ordena_ya/core/token/token_storage.dart';

abstract class CreateOrderRemoteDataSource {
  Future<OrderResponseModel> createOrder(CreateOrderRequestModel orderRequest);
  Future<OrderResponseModel> updateOrder(String orderId, CreateOrderRequestModel orderRequest);
  Future<OrderResponseModel> closeOrder(String orderId);
}

class CreateOrderRemoteDataSourceImpl implements CreateOrderRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  CreateOrderRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<OrderResponseModel> createOrder(CreateOrderRequestModel orderRequest) async {
    try {
      final url = ApiConfig.ordersEndpoint;
      final body = json.encode(orderRequest.toJson());
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Creating order at: $url');
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
          Logger.error('Create order timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Create order response status: ${response.statusCode}');
      Logger.info('Create order response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decodificar con UTF-8 explícitamente
        final String responseBody = utf8.decode(response.bodyBytes);
        Logger.info('Create order response body: $responseBody');
        final Map<String, dynamic> json = jsonDecode(responseBody);
        Logger.info('Parsed JSON: $json');
        final order = OrderResponseModel.fromJson(json);

        Logger.info('Successfully created order: ${order.id}');
        Logger.info('Order model details - ID: ${order.id}, Mesa: ${order.mesa}');
        return order;
      } else {
        Logger.error('Failed to create order: ${response.statusCode}');
        throw Exception('Failed to create order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error creating order: $e');
      throw Exception('Error creating order: $e');
    }
  }

  @override
  Future<OrderResponseModel> updateOrder(String orderId, CreateOrderRequestModel orderRequest) async {
    try {
      final url = '${ApiConfig.ordersEndpoint}/$orderId';
      final body = json.encode(orderRequest.toJson());
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Updating order at: $url');
      Logger.info('Request body: $body');

      final response = await client.put(
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
          Logger.error('Update order timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Update order response status: ${response.statusCode}');
      Logger.info('Update order response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decodificar con UTF-8 explícitamente
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final order = OrderResponseModel.fromJson(json);

        Logger.info('Successfully updated order: ${order.id}');
        return order;
      } else {
        Logger.error('Failed to update order: ${response.statusCode}');
        throw Exception('Failed to update order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error updating order: $e');
      throw Exception('Error updating order: $e');
    }
  }

  @override
  Future<OrderResponseModel> closeOrder(String orderId) async {
    try {
      final url = '${ApiConfig.ordersEndpoint}/$orderId/close';
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Closing order at: $url');

      final response = await client.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          Logger.error('Close order timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Close order response status: ${response.statusCode}');
      Logger.info('Close order response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decodificar con UTF-8 explícitamente
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final order = OrderResponseModel.fromJson(json);

        Logger.info('Successfully closed order: ${order.id}');
        return order;
      } else {
        Logger.error('Failed to close order: ${response.statusCode}');
        throw Exception('Failed to close order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error closing order: $e');
      throw Exception('Error closing order: $e');
    }
  }
}