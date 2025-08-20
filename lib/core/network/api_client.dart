// core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({
    required this.baseUrl,
    required this.client,
  });

  /// 🔹 GET → retorna un objeto dinámico (mapa o lista)
  Future<dynamic> get(String endpoint) async {
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error GET $endpoint: ${response.statusCode}');
    }
  }

  /// 🔹 POST → crear recurso
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error POST $endpoint: ${response.statusCode}');
    }
  }

  /// 🔹 PUT → reemplazar recurso completo
  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error PUT $endpoint: ${response.statusCode}');
    }
  }

  /// 🔹 PATCH → actualizar parcialmente
  Future<Map<String, dynamic>> patch(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error PATCH $endpoint: ${response.statusCode}');
    }
  }

  /// 🔹 DELETE → eliminar recurso
  Future<void> delete(String endpoint) async {
    final response = await client.delete(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error DELETE $endpoint: ${response.statusCode}');
    }
  }
}
