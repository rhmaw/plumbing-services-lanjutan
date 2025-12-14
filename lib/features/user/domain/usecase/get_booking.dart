import 'package:plumbing_services_pml_kel4/features/user/domain/entities/booking_entity.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/repositories/user_repository.dart';

class GetBooking {
  final UserRepository repository;
  GetBooking(this.repository);

  Future<void> execute(Booking booking) async {
    return await repository.getBookingsByStatus(booking);
  }
}