import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/order_response_model.dart';
import 'package:ordena_ya/core/token/token_storage.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderResponseModel>> getAllOrders();
  Future<OrderResponseModel> getOrderById(String id);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  OrdersRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<List<OrderResponseModel>> getAllOrders() async {
    try {
      final url = ApiConfig.ordersEndpoint;
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Fetching orders from: $url');
      Logger.info('API Config: ${ApiConfig.info}');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Logger.error('Request timeout after 10 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Response status: ${response.statusCode}');
      Logger.info('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decodificar con UTF-8 explícitamente
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = json.decode(responseBody);
        final orders =
            jsonList.map((json) => OrderResponseModel.fromJson(json)).toList();

        Logger.info('Successfully parsed ${orders.length} orders');
        return orders;
      } else {
        Logger.error('Failed to fetch orders: ${response.statusCode}');
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  @override
  Future<OrderResponseModel> getOrderById(String id) async {
    try {
      final url = '${ApiConfig.ordersEndpoint}/$id';
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Fetching order by ID from: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Logger.error('Request timeout after 10 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Response status: ${response.statusCode}');
      Logger.info('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decodificar con UTF-8 explícitamente
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final order = OrderResponseModel.fromJson(json);

        Logger.info('Successfully parsed order: ${order.id}');
        return order;
      } else {
        Logger.error('Failed to fetch order: ${response.statusCode}');
        throw Exception('Failed to fetch order: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error fetching order by ID: $e');
      throw Exception('Error fetching order by ID: $e');
    }
  }
}
