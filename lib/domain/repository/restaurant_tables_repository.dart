import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import '../entity/restaurant_table.dart';

abstract class RestaurantTableRepository {
  Future<Either<Failure, List<RestaurantTable>>> getAllTables();
  Future<Either<Failure, RestaurantTable>> selectTableForOrder(int id, SelectTableModel table);
}
