import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/restaurant_table.dart';

abstract class RestaurantTableRepository {
  Future<Either<Failure, List<RestaurantTable>>> getAllTables();
  Future<Either<Failure, RestaurantTable>> updateTable(RestaurantTable table);
}
