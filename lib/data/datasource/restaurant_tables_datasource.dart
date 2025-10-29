import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import 'package:ordena_ya/data/model/table_model.dart';
import 'package:ordena_ya/data/model/table_models.dart';
import 'package:ordena_ya/core/token/token_storage.dart';

abstract class RestaurantTableRemoteDataSource {
  Future<List<TableModel>> fetchTables();
  Future<TableModel> selectTableForOrder(int id, SelectTableModel table);
}

class RestaurantTableRemoteDataSourceImpl implements RestaurantTableRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  RestaurantTableRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<List<TableModel>> fetchTables() async {
    try {
      final url = ApiConfig.tablesEndpoint;
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Fetching tables from: $url');

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
          Logger.error('Fetch tables timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Fetch tables response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final tableResponse = TableResponseModel.fromJson(json);
        
        // Convertir TableDataModel a TableModel (modelo existente)
        final tables = tableResponse.tables.map((tableData) {
          return TableModel(
            id: int.tryParse(tableData.id) ?? 0, // Convertir string ID a int si es necesario
            tenantId: 1, // ID del tenant por defecto
            tableNumber: tableData.number.toString(),
            capacity: tableData.capacity,
            status: tableData.status,
            location: tableData.location,
          );
        }).toList();

        Logger.info('Successfully fetched ${tables.length} tables');
        return tables;
      } else {
        Logger.error('Failed to fetch tables: ${response.statusCode}');
        throw Exception('Failed to fetch tables: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error fetching tables: $e');
      throw Exception('Error fetching tables: $e');
    }
  }
  
  @override
  Future<TableModel> selectTableForOrder(int id, SelectTableModel table) async {
    try {
      final url = '${ApiConfig.tablesEndpoint}/$id';
      final body = json.encode(table.toJson());
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      
      Logger.info('Selecting table at: $url');
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
          Logger.error('Select table timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Select table response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final tableModel = TableModel.fromJson(json['table']);

        Logger.info('Successfully selected table: ${tableModel.tableNumber}');
        return tableModel;
      } else {
        Logger.error('Failed to select table: ${response.statusCode}');
        throw Exception('Failed to select table: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error selecting table: $e');
      throw Exception('Error selecting table: $e');
    }
  }
}