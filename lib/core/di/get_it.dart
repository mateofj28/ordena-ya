import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/network/api_client.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/data/repository/order_repository_imple.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Cliente HTTP
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: getIt<http.Client>(),
      baseUrl: 'http://179.33.214.87:3001/api',
    ),
  );

  // DataSource
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositorio
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrderRepository>()),
  );
}
