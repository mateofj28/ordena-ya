import 'package:dartz/dartz.dart';
import 'package:ordena_ya/core/error/failures.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/data/datasource/create_order_remote_datasource.dart';
import 'package:ordena_ya/data/model/create_order_request_model.dart';
import 'package:ordena_ya/domain/entity/order_response.dart';
import 'package:ordena_ya/domain/repository/create_order_repository.dart';

class CreateOrderRepositoryImpl implements CreateOrderRepository {
  final CreateOrderRemoteDataSource remoteDataSource;

  CreateOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderRequestModel orderRequest) async {
    try {
      Logger.info('Repository: Creating order');
      
      final orderModel = await remoteDataSource.createOrder(orderRequest);
      final entity = orderModel.toEntity();
      
      Logger.info('Repository: Successfully created order');
      return Right(entity);
    } catch (e) {
      Logger.error('Repository: Error creating order: $e');
      return Left(ServerFailure(message: 'Error al crear la orden: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderResponseEntity>> updateOrder(String orderId, CreateOrderRequestModel orderRequest) async {
    try {
      Logger.info('Repository: Updating order: $orderId');
      
      final orderModel = await remoteDataSource.updateOrder(orderId, orderRequest);
      final entity = orderModel.toEntity();
      
      Logger.info('Repository: Successfully updated order');
      return Right(entity);
    } catch (e) {
      Logger.error('Repository: Error updating order: $e');
      return Left(ServerFailure(message: 'Error al actualizar la orden: $e'));
    }
  }
}