import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/restaurant_table.dart';
import '../repository/restaurant_tables_repository.dart';

class GetTablesUseCase {
  final RestaurantTableRepository repository;

  GetTablesUseCase(this.repository);

  Future<Either<Failure, List<RestaurantTable>>> call() {
    return repository.getAllTables();
  }
}
