import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/domain/dto/register_order_req.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';



class OrderRepositoryImpl implements OrderRepository {

  final OrderRemoteDataSource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Order>> createOrder(CreateOrderReq order) async {
    try {
      final created = await datasource.createOrder(order);
      return Right(created);
    } catch (e, stack) {
      Logger.error('Error creating order: $e');          
      Logger.error('Stacktrace: $stack');      
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getAllOrders() async {
    try {
      final orders = await datasource.fetchOrders();
      return Right(orders);
    } catch (e, stack) {
      Logger.error('Error getting orders: $e');          
      Logger.error('Stacktrace: $stack');
      return Left(ServerFailure(e.toString()));
    }
  }

}