class Table {
  final String number;
  final int capacity;
  final String? location;
  final String status;

  Table({
    required this.number,
    required this.capacity,
    this.location,
    required this.status,
  });
}
