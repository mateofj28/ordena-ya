import 'package:ordena_ya/data/model/restaurant_table_model.dart';
import 'package:ordena_ya/core/network/api_client.dart';

abstract class RestaurantTableRemoteDataSource {
  Future<List<RestaurantTableModel>> fetchTables();
  Future<RestaurantTableModel> updateTable(RestaurantTableModel table);
}

class RestaurantTableRemoteDataSourceImpl implements RestaurantTableRemoteDataSource {
  final ApiClient apiClient;

  RestaurantTableRemoteDataSourceImpl({ required this.apiClient });

  @override
  Future<List<RestaurantTableModel>> fetchTables() async {
    final res = await apiClient.get('/restaurant_tables');
    return (res as List).map((e) => RestaurantTableModel.fromJson(e)).toList();
  }

  @override
  Future<RestaurantTableModel> updateTable(RestaurantTableModel table) async {
    final res = await apiClient.patch('/restaurant_tables/${table.id}', table.toJson());
    return RestaurantTableModel.fromJson(res);
  }
}
