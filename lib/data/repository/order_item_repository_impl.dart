import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/dto/order_item.dart';
import 'package:ordena_ya/domain/repository/order_item_repository.dart';
import '../datasource/order_item_datasource.dart';


class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemRemoteDataSource datasource;

  OrderItemRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, void>> addItemToOrder(String orderId, OrderItem item) async {
    try {
      await datasource.addItemToOrder(orderId, item );
      return Right(null);
    } catch (e) {           
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateItemInOrder(String orderId, int itemId, OrderItem item) async {
    try {
      await datasource.updateItemInOrder(orderId, itemId, item);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteItemToOrder(String orderId, String productId) async {
    try {
      await datasource.deleteItemToOrder(orderId, productId);
      return Right(null);
    } catch (e) {           
      return Left(ServerFailure(e.toString()));
    }
  }
}
