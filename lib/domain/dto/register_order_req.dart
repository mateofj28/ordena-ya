class CreateOrderReq {
  final int tenantId;
  final int tableId;
  final int peopleCount;
  final String consumptionType;
  final String? clientId;

  const CreateOrderReq({
    required this.tenantId,
    required this.tableId,
    required this.peopleCount,
    required this.consumptionType,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'tableId': tableId,
      'peopleCount': peopleCount,
      'consumptionType': consumptionType,
      'clientId': clientId,
    };
  }
}
