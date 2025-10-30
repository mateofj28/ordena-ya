import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/token/token_storage.dart';
import 'package:ordena_ya/data/model/enriched_order_model.dart';

abstract class EnrichedOrderRemoteDataSource {
  Future<List<EnrichedOrderModel>> fetchEnrichedOrders();
}

class EnrichedOrderRemoteDataSourceImpl implements EnrichedOrderRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  EnrichedOrderRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<List<EnrichedOrderModel>> fetchEnrichedOrders() async {
    try {
      final url = ApiConfig.ordersEndpoint;
      final token = await tokenStorage.getToken();

      final response = await client.get(
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
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        
        try {
          final List<dynamic> ordersJson = jsonDecode(responseBody);
          
          // Convertir cada orden usando el nuevo modelo enriquecido
          final orders = ordersJson.map((orderJson) {
            return EnrichedOrderModel.fromJson(orderJson);
          }).toList();

          return orders;
        } catch (parseError) {
          throw Exception('Error parsing enriched orders response: $parseError');
        }
      } else {
        throw Exception('Failed to fetch enriched orders: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch enriched orders from server: $e');
    }
  }
}