import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';

class OrderRepositoryImple implements OrderRepository {

  final OrderDatasource datasource;

  OrderRepositoryImple(this.datasource);

  @override
  Future<Either<Failure, void>> createOrder(Order order) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Order>>> getAllOrders() async {
    try {
      final orders = await datasource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}