import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/entity/order_item.dart';
import 'package:ordena_ya/domain/repository/order_item_repository.dart';
import '../datasource/order_item_datasource.dart';
import '../model/order_item_model.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemRemoteDataSource datasource;

  OrderItemRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, OrderItem>> addItemToOrder(String orderId, OrderItem item) async {
    try {
      final added = await datasource.addItemToOrder(orderId, OrderItemModel.fromEntity(item));
      return Right(added.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderItem>> updateItemInOrder(String orderId, String itemId, OrderItem item) async {
    try {
      final updated = await datasource.updateItemInOrder(orderId, itemId, OrderItemModel.fromEntity(item));
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
