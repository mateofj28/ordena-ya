# Modelo de Órdenes Enriquecidas

Este documento explica cómo usar el nuevo modelo `EnrichedOrderModel` que aprovecha la información enriquecida automáticamente por la API.

## ✅ Beneficios del Nuevo Modelo

### 1. **Menos Requests HTTP**
```dart
// ❌ ANTES: Múltiples requests
final orders = await getOrders();
for (final order in orders) {
  final table = await getTable(order.tableId);  // Request adicional
  final company = await getCompany(order.companyId);  // Request adicional
}

// ✅ AHORA: Un solo request
final orders = await getEnrichedOrders();  // Toda la info incluida
```

### 2. **Información Completa Inmediata**
```dart
// ✅ Información de mesa ya incluida
if (order.tableInfo != null) {
  print('Mesa ${order.tableInfo!.number}');
  print('Ubicación: ${order.tableInfo!.location}');
  print('Capacidad: ${order.tableInfo!.capacity} personas');
}

// ✅ Información de empresa ya incluida
if (order.companyInfo != null) {
  print('Empresa: ${order.companyInfo!.name}');
  print('Dirección: ${order.companyInfo!.address}');
}

// ✅ Información del creador ya incluida
if (order.createdByInfo != null) {
  print('Creado por: ${order.createdByInfo!.name} (${order.createdByInfo!.role})');
}
```

## 📋 Estructura del Modelo

### Campos Principales
- `id`: ID de la orden
- `orderType`: Tipo de orden (table, delivery, takeout)
- `tableId`: ID de la mesa (si aplica)
- `peopleCount`: Número de personas
- `requestedProducts`: Lista de productos con snapshot histórico
- `itemCount`: Cantidad total de items
- `total`: Total de la orden
- `createdAt`: Fecha de creación
- `status`: Estado de la orden

### Información Enriquecida (Opcional)
- `tableInfo`: Información completa de la mesa
- `companyInfo`: Información de la empresa
- `createdByInfo`: Información del creador

## 🚀 Cómo Usar

### 1. **En Datasources**
```dart
class EnrichedOrderRemoteDataSourceImpl {
  Future<List<EnrichedOrderModel>> fetchEnrichedOrders() async {
    final response = await client.get(Uri.parse(ApiConfig.ordersEndpoint));
    final List<dynamic> ordersJson = jsonDecode(response.body);
    
    return ordersJson.map((json) => EnrichedOrderModel.fromJson(json)).toList();
  }
}
```

### 2. **En Widgets**
```dart
class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnrichedOrdersList(
      orders: enrichedOrders,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRefresh: () => loadOrders(),
    );
  }
}
```

### 3. **Mostrar Información Enriquecida**
```dart
Widget buildOrderCard(EnrichedOrderModel order) {
  return Card(
    child: Column(
      children: [
        // Título con información de mesa enriquecida
        Text(order.tableInfo != null 
          ? 'Mesa ${order.tableInfo!.number} - ${order.tableInfo!.location}'
          : 'Orden ${order.id}'),
        
        // Productos con snapshot histórico
        ...order.requestedProducts.map((product) => ListTile(
          title: Text(product.productSnapshot.name),
          subtitle: Text('\$${product.productSnapshot.price}'),
          trailing: Text('x${product.requestedQuantity}'),
        )),
        
        // Información del creador
        if (order.createdByInfo != null)
          Text('Por: ${order.createdByInfo!.name}'),
      ],
    ),
  );
}
```

## 🔄 Migración desde Modelo Anterior

### Cambios Necesarios
1. **Reemplazar imports**:
   ```dart
   // ❌ Antes
   import 'package:ordena_ya/domain/entity/order_response.dart';
   
   // ✅ Ahora
   import 'package:ordena_ya/data/model/enriched_order_model.dart';
   ```

2. **Actualizar tipos**:
   ```dart
   // ❌ Antes
   List<OrderResponseEntity> orders;
   
   // ✅ Ahora
   List<EnrichedOrderModel> orders;
   ```

3. **Usar información enriquecida**:
   ```dart
   // ❌ Antes: Request adicional necesario
   final table = await getTable(order.tableId);
   Text('Mesa ${table.number}');
   
   // ✅ Ahora: Información ya incluida
   Text(order.tableInfo != null 
     ? 'Mesa ${order.tableInfo!.number}' 
     : 'Mesa ${order.tableId}');
   ```

## 🎯 Casos de Uso Comunes

### 1. **Lista de Órdenes**
```dart
ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index];
    return EnrichedOrderCard(order: order);
  },
)
```

### 2. **Estadísticas**
```dart
final tableOrders = orders.where((o) => o.orderType == 'table').length;
final totalRevenue = orders.fold<double>(0, (sum, o) => sum + o.total);
final avgOrderValue = totalRevenue / orders.length;
```

### 3. **Filtros por Mesa**
```dart
final mesaOrders = orders.where((order) => 
  order.tableInfo?.number == 5
).toList();
```

### 4. **Filtros por Creador**
```dart
final meseroOrders = orders.where((order) => 
  order.createdByInfo?.role == 'mesero'
).toList();
```

## ⚠️ Consideraciones

### Campos Opcionales
Siempre verificar si los campos enriquecidos existen:
```dart
// ✅ Correcto
if (order.tableInfo != null) {
  print('Mesa ${order.tableInfo!.number}');
}

// ❌ Incorrecto - puede causar null pointer
print('Mesa ${order.tableInfo.number}');  // Error si tableInfo es null
```

### Fallbacks
Proporcionar fallbacks para información faltante:
```dart
String getTableDisplay(EnrichedOrderModel order) {
  if (order.tableInfo != null) {
    return 'Mesa ${order.tableInfo!.number}';
  } else if (order.tableId != null) {
    return 'Mesa ${order.tableId}';
  } else {
    return 'Sin mesa asignada';
  }
}
```

## 🔧 Archivos Creados

1. **`enriched_order_model.dart`**: Modelo principal con toda la estructura
2. **`enriched_order_card.dart`**: Widget optimizado para mostrar órdenes
3. **`enriched_orders_list.dart`**: Lista y estadísticas de órdenes
4. **`enriched_order_datasource.dart`**: Datasource para obtener órdenes enriquecidas

## 📈 Performance

- **Menos requests**: De N+1 requests a 1 solo request
- **Menos estados de loading**: Una sola carga para toda la información
- **Mejor UX**: Información completa disponible inmediatamente
- **Código más simple**: No necesitas manejar múltiples datasources