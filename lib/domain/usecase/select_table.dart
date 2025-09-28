import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import '../entity/restaurant_table.dart';
import '../repository/restaurant_tables_repository.dart';

class SelectTableUseCase {
  final RestaurantTableRepository repository;

  SelectTableUseCase(this.repository);

  Future<Either<Failure, RestaurantTable>> call(int id, SelectTableModel table) {
    return repository.selectTableForOrder(id, table);
  }
}
