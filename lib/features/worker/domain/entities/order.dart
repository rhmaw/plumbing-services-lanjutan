class Order {
  final int idOrder;
  final String customerName;
  final String address;
  final String serviceType;
  final String serviceTime;
  final String status;

  Order({
    required this.idOrder,
    required this.customerName,
    required this.address,
    required this.serviceType,
    required this.serviceTime,
    required this.status,
  });
}
