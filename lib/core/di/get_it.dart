import 'package:get_it/get_it.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/data/repository/order_repository_imple.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';



final getIt = GetIt.instance;


void setupLocator() {
  // Servicios
  getIt.registerLazySingleton<OrderDatasource>(() => OrderDatasource());

  // Repositorios
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImple(getIt<OrderDatasource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrderRepository>()),
  );
}
