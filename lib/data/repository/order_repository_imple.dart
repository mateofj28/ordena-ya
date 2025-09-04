import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/domain/entity/order.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {

  final OrderRemoteDataSource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      final created = await datasource.createOrder(OrderModel.fromEntity(order));
      return Right(created);
    } catch (e, stack) {
      print('Error: $e');          // mensaje del error
      print('Stacktrace: $stack');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getAllOrders() async {
    try {
      final orders = await datasource.fetchOrders();
      return Right(orders);
    } catch (e, stack) {
      print('Error: $e');          // mensaje del error
      print('Stacktrace: $stack');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Order>>> getAllOrdersToday(String date) async {
    try {
      final orders = await datasource.fetchOrdersToday(date);
      return Right(orders);
    } catch (e, stack) {
      print('Error: $e');          // mensaje del error
      print('Stacktrace: $stack');
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, int>> getOrderId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderId = prefs.getInt("ORDER_ID");

      if (orderId == null) {
        return Left(ServerFailure("No se encontro un ID de orden"));
      }      
      return Right(orderId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> setOrderId(int orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("ORDER_ID", orderId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}