import 'package:plumbing_services_pml_kel4/features/user/domain/entities/booking_entity.dart';

abstract class UserRepository {
Future<List<Booking>> getOrderHistory(String status);

Future<void> createBooking(Booking booking);
Future<void> getBookingsByStatus(Booking booking);


}
