import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/token/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  final TokenStorage tokenStorage;

  ApiClient({
    required this.baseUrl,
    required this.client,
    required this.tokenStorage,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return json.decode(response.body);
    } catch (_) {
      return response.body;
    }
  }

  /// GET → devuelve dinámico (Map o List) o null si 204
  Future<dynamic> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return _decodeBody(response);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('Error GET $endpoint: ${response.statusCode} - ${response.body}');
    }
  }

  /// POST → devuelve Map<String, dynamic> (si la respuesta es un objeto)
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );

    final decoded = _decodeBody(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } else {
      throw Exception('Error POST $endpoint: ${response.statusCode} - ${response.body}');
    }
  }

  /// PUT → devuelve Map<String, dynamic> o {} en 204
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final response = await client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );

    final decoded = _decodeBody(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } else if (response.statusCode == 204) {
      return {};
    } else {
      throw Exception('Error PUT $endpoint: ${response.statusCode} - ${response.body}');
    }
  }

  /// PATCH → devuelve Map<String, dynamic> o {} en 204
  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async {
    final response = await client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );

    final decoded = _decodeBody(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } else if (response.statusCode == 204) {
      return {};
    } else {
      throw Exception('Error PATCH $endpoint: ${response.statusCode} - ${response.body}');
    }
  }

  /// DELETE → no devuelve contenido (void), lanza si falla
  Future<void> delete(String endpoint) async {
    final response = await client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Error DELETE $endpoint: ${response.statusCode} - ${response.body}');
    }
  }

  /// Permite forzar actualizar el token en memoria si lo necesitas
  /// (si manejas caching interno en el ApiClient)
  // void setApiToken(String token) {
  //   // Si guardas un cache local del token, asigna aquí
  // }
}
