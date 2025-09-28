import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import '../../domain/entity/restaurant_table.dart';
import '../../domain/repository/restaurant_tables_repository.dart';
import '../datasource/restaurant_tables_datasource.dart';

class RestaurantTableRepositoryImpl implements RestaurantTableRepository {
  final RestaurantTableRemoteDataSource datasource;

  RestaurantTableRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<RestaurantTable>>> getAllTables() async {
    try {
      final tables = await datasource.fetchTables();
      return Right(tables.map((e) => e.toEntity()).toList());
    } catch (e) {  
      return Left(ServerFailure(e.toString()));
    }
  }  

  @override
  Future<Either<Failure, RestaurantTable>> selectTableForOrder(int id, SelectTableModel tableRequest) async {
    try {
      final table = await datasource.selectTableForOrder(id, tableRequest);
      return Right(table.toEntity());
    } catch (e) {  
      return Left(ServerFailure(e.toString()));
    }
  }
}
