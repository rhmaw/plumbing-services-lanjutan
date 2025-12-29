import '../entities/booking_entity.dart';
import '../repositories/user_repository.dart';


class GetOrderHistory {
  final UserRepository repository;

  GetOrderHistory(this.repository);

  Future<List<Booking>> execute(String status) async {
    return await repository.getOrderHistory(status);
  }
}
