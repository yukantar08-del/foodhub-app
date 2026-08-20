enum UserRole {
  customer,
  merchant,
  driver,
  admin,
}

enum OrderStatus {
  created,
  accepted,
  preparing,
  ready,
  assigned,
  pickedUp,
  onTheWay,
  delivered,
}

class DemoOrder {
  final String id;
  final String merchantName;
  final double itemTotal;
  final double deliveryFee;
  final double customerTotal;
  final String? driverName;
  final OrderStatus status;

  const DemoOrder({
    required this.id,
    required this.merchantName,
    required this.itemTotal,
    required this.deliveryFee,
    required this.customerTotal,
    required this.status,
    this.driverName,
  });

  DemoOrder copyWith({
    String? id,
    String? merchantName,
    double? itemTotal,
    double? deliveryFee,
    double? customerTotal,
    String? driverName,
    OrderStatus? status,
  }) {
    return DemoOrder(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      itemTotal: itemTotal ?? this.itemTotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      customerTotal: customerTotal ?? this.customerTotal,
      driverName: driverName ?? this.driverName,
      status: status ?? this.status,
    );
  }
}
