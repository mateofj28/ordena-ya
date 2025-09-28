
import 'package:ordena_ya/core/network/api_client.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import 'package:ordena_ya/data/model/table_model.dart';

abstract class RestaurantTableRemoteDataSource {
  Future<List<TableModel>> fetchTables();
  Future<TableModel> selectTableForOrder(int id, SelectTableModel table);
}

class RestaurantTableRemoteDataSourceImpl implements RestaurantTableRemoteDataSource {
  final ApiClient apiClient;

  RestaurantTableRemoteDataSourceImpl({ required this.apiClient });

  @override
  Future<List<TableModel>> fetchTables() async {
    final res = await apiClient.get('/tables');
    List<dynamic> tableListMap = res['tables'];
    return tableListMap.map((e) => TableModel.fromJson(e)).toList();
  }
  
  @override
  Future<TableModel> selectTableForOrder(int id, SelectTableModel table) async {
    final res = await apiClient.put('/tables/$id', table.toJson());
    dynamic mapTable = res['table'];
    return TableModel.fromJson(mapTable);
  }

  
}
