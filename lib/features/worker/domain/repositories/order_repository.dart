import '../../domain/entities/order.dart';

abstract class OrderRepository {
  Future<Order?> getWaitingOrderForWorker(int workerId);
  Future<void> acceptOrder(int orderId);
}
