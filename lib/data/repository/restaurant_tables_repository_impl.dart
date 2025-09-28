import 'package:flutter/material.dart';
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../../domain/entity/restaurant_table.dart';
import '../../domain/repository/restaurant_tables_repository.dart';
import '../datasource/restaurant_tables_datasource.dart';

class RestaurantTableRepositoryImpl implements RestaurantTableRepository {
  final RestaurantTableRemoteDataSource datasource;

  RestaurantTableRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<RestaurantTable>>> getAllTables() async {
    try {
      final tables = await datasource.fetchTables();
      return Right(tables.map((e) => e.toEntity()).toList());
    } catch (e, stra) {
      debugPrint("❌ Error en fetchTables: $e");
      debugPrint("📌 StackTrace: $stra");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantTable>> updateTable(RestaurantTable table) {
    // TODO: implement updateTable
    throw UnimplementedError();
  }
}
