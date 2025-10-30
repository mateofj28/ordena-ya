// Ejemplo de cómo configurar el sistema de órdenes enriquecidas
// Este archivo muestra cómo integrar el nuevo sistema con el existente

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/token/token_storage.dart';
import 'package:ordena_ya/data/datasource/enriched_order_datasource.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';

// Función para configurar las órdenes enriquecidas en el sistema de DI
void setupEnrichedOrders() {
  final getIt = GetIt.instance;

  // Registrar el datasource de órdenes enriquecidas
  getIt.registerLazySingleton<EnrichedOrderRemoteDataSource>(
    () => EnrichedOrderRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // Actualizar el registro del OrderSetupProvider para incluir el datasource enriquecido
  // NOTA: Esto reemplazaría el registro existente en get_it.dart
  /*
  getIt.registerFactory<OrderSetupProvider>(
    () => OrderSetupProvider(
      createOrderUseCase: getIt<CreateOrder>(),
      addItemToOrderUseCase: getIt<AddItemToOrderUseCase>(),
      getAllOrdersUseCase: getIt<GetOrdersUseCase>(),
      getAllOrdersNewUseCase: getIt<GetAllOrdersNewUseCase>(),
      createOrderNewUseCase: getIt<CreateOrderNewUseCase>(),
      updateOrderUseCase: getIt<UpdateOrderUseCase>(),
      closeOrderUseCase: getIt<CloseOrderUseCase>(),
      enrichedOrderDataSource: getIt<EnrichedOrderRemoteDataSource>(), // ← NUEVO
    ),
  );
  */
}

// Función para habilitar órdenes enriquecidas en un provider existente
void enableEnrichedOrdersForProvider(OrderSetupProvider provider) {
  // Si ya tienes un provider instanciado y quieres agregar el datasource enriquecido
  final getIt = GetIt.instance;
  
  if (getIt.isRegistered<EnrichedOrderRemoteDataSource>()) {
    // El datasource ya está registrado, se puede usar
    // Nota: Esto requeriría modificar el provider para permitir inyección posterior
    // o usar un patrón diferente
  }
}

// Ejemplo de uso en main.dart o donde configures los providers
/*
void main() {
  // Configurar DI normal
  setupDependencyInjection();
  
  // Configurar órdenes enriquecidas
  setupEnrichedOrders();
  
  runApp(MyApp());
}
*/

// Ejemplo de uso con Provider
/*
MultiProvider(
  providers: [
    ChangeNotifierProvider<OrderSetupProvider>(
      create: (context) => OrderSetupProvider(
        // ... otros parámetros
        enrichedOrderDataSource: GetIt.instance<EnrichedOrderRemoteDataSource>(),
      ),
    ),
    // ... otros providers
  ],
  child: MyApp(),
)
*/