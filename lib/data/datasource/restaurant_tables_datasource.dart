
import 'package:ordena_ya/core/network/api_client.dart';
import 'package:ordena_ya/data/model/table_model.dart';

abstract class RestaurantTableRemoteDataSource {
  Future<List<TableModel>> fetchTables();
  // Future<RestaurantTableModel> updateTable(RestaurantTableModel table);
}

class RestaurantTableRemoteDataSourceImpl implements RestaurantTableRemoteDataSource {
  final ApiClient apiClient;

  RestaurantTableRemoteDataSourceImpl({ required this.apiClient });

  @override
  Future<List<TableModel>> fetchTables() async {
    final res = await apiClient.get('/tables');
    Map<String, dynamic> tableListMap = res['tables'];
    return (tableListMap as List).map((e) => TableModel.fromJson(e)).toList();
  }

  // @override
  // Future<RestaurantTableModel> updateTable(RestaurantTableModel table) async {
  //   final res = await apiClient.patch('/restaurant_tables/${table.id}', table.toJson());
  //   return RestaurantTableModel.fromJson(res);
  // }
}
