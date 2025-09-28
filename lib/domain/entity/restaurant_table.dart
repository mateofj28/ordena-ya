class RestaurantTable {
  final int id;
  final int tenantId;
  final String tableNumber;
  final int capacity;
  final String status;
  final String location;

  RestaurantTable({
    required this.id,
    required this.tenantId,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    required this.location,
  });
}
