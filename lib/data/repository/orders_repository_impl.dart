import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/datasource/orders_remote_datasource.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderResponseEntity>>> getAllOrders() async {
    try {
      Logger.info('Repository: Getting all orders');
      
      final orders = await remoteDataSource.getAllOrders();
      final entities = orders.map((model) => model.toEntity()).toList();
      
      Logger.info('Repository: Successfully converted ${entities.length} orders to entities');
      return Right(entities);
    } catch (e) {
      Logger.error('Repository: Error getting orders: $e');
      return Left(ServerFailure(message: 'Error al obtener las órdenes: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderResponseEntity>> getOrderById(String id) async {
    try {
      Logger.info('Repository: Getting order by ID: $id');
      
      final order = await remoteDataSource.getOrderById(id);
      final entity = order.toEntity();
      
      Logger.info('Repository: Successfully converted order to entity');
      return Right(entity);
    } catch (e) {
      Logger.error('Repository: Error getting order by ID: $e');
      return Left(ServerFailure(message: 'Error al obtener la orden: $e'));
    }
  }
}