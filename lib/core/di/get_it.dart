import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/network/api_client.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/data/datasource/order_item_datasource.dart';
import 'package:ordena_ya/data/repository/order_item_repository_impl.dart';
import 'package:ordena_ya/data/repository/order_repository_imple.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';
import '../../domain/repository/order_item_repository.dart';
import '../../domain/usecase/add_item_to_order.dart';
import '../../domain/usecase/create_order.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Cliente HTTP
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: getIt<http.Client>(),
      baseUrl: 'http://179.33.214.87:3013/api',
    ),
  );

  // DataSource
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<OrderItemRemoteDataSource>(
        () => OrderItemRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositorio
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );

  getIt.registerLazySingleton<OrderItemRepository>(
        () => OrderItemRepositoryImpl(getIt<OrderItemRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<CreateOrder>(
        () => CreateOrder(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<AddItemToOrderUseCase>(
        () => AddItemToOrderUseCase(getIt<OrderItemRepository>()),
  );


}
