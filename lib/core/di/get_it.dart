import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/network/api_client.dart';
import 'package:ordena_ya/core/token/token_storage.dart';
import 'package:ordena_ya/data/datasource/order_datasource.dart';
import 'package:ordena_ya/data/datasource/order_item_datasource.dart';
import 'package:ordena_ya/data/datasource/product_datasource.dart';
import 'package:ordena_ya/data/datasource/restaurant_tables_datasource.dart';
import 'package:ordena_ya/data/datasource/user_datasource.dart';
import 'package:ordena_ya/data/repository/order_item_repository_impl.dart';
import 'package:ordena_ya/data/repository/order_repository_imple.dart';
import 'package:ordena_ya/data/repository/product_repository_impl.dart';
import 'package:ordena_ya/data/repository/restaurant_tables_repository_impl.dart';
import 'package:ordena_ya/data/repository/user_repository_impl.dart';
import 'package:ordena_ya/domain/repository/order_repository.dart';
import 'package:ordena_ya/domain/repository/product_repository.dart';
import 'package:ordena_ya/domain/repository/restaurant_tables_repository.dart';
import 'package:ordena_ya/domain/repository/user_repository.dart';
import 'package:ordena_ya/domain/usecase/create_client.dart';
import 'package:ordena_ya/domain/usecase/create_user.dart';
import 'package:ordena_ya/domain/usecase/get_all_orders.dart';
import 'package:ordena_ya/domain/usecase/get_all_products.dart';
import 'package:ordena_ya/domain/usecase/get_all_tables.dart';
import 'package:ordena_ya/domain/usecase/login.dart';
import 'package:ordena_ya/domain/usecase/select_table.dart';
import '../../domain/repository/order_item_repository.dart';
import '../../domain/usecase/add_item_to_order.dart';
import '../../domain/usecase/create_order.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(getIt<FlutterSecureStorage>()),
  );

  // Cliente HTTP
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: getIt<http.Client>(),
      baseUrl: 'http://205.209.122.84:3013/api',
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // DataSource
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<OrderItemRemoteDataSource>(
    () => OrderItemRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImple(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<RestaurantTableRemoteDataSource>(
    () => RestaurantTableRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositorio
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );

  getIt.registerLazySingleton<OrderItemRepository>(
    () => OrderItemRepositoryImpl(getIt<OrderItemRemoteDataSource>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      getIt<UserRemoteDataSource>(),
      getIt<TokenStorage>(),
    ),
  );

  getIt.registerLazySingleton<RestaurantTableRepository>(
    () =>
        RestaurantTableRepositoryImpl(getIt<RestaurantTableRemoteDataSource>()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
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

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetTablesUseCase>(
    () => GetTablesUseCase(getIt<RestaurantTableRepository>()),
  );

  getIt.registerLazySingleton<SelectTableUseCase>(
    () => SelectTableUseCase(getIt<RestaurantTableRepository>()),
  );

  getIt.registerLazySingleton<CreateClient>(
    () => CreateClient(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(getIt<ProductRepository>()),
  );
}
