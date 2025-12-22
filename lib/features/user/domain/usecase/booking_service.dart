import '../entities/booking_entity.dart';
import '../repositories/user_repository.dart';

class BookingWorker {
  final UserRepository repository;

  BookingWorker(this.repository);

  Future<void> execute(Booking booking) async {
    return await repository.createBooking(booking);
  }
}
