import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/restaurant_table.dart';
import '../repository/restaurant_tables_repository.dart';

class UpdateTableUseCase {
  final RestaurantTableRepository repository;

  UpdateTableUseCase(this.repository);

  Future<Either<Failure, RestaurantTable>> call(RestaurantTable table) {
    return repository.updateTable(table);
  }
}
