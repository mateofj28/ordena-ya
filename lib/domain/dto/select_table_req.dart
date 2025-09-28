class SelectTableRequest {
  final String number;
  final int capacity;
  final String location;
  final String status;

  SelectTableRequest({
    required this.number,
    required this.capacity,
    required this.location,
    required this.status,
  });
}
