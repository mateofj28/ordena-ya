class RestaurantTable {
  final int id;
  final int restaurantId;
  final String name;
  final int capacity;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantTable({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
