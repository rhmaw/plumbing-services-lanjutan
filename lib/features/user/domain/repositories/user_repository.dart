
import 'package:plumbing_services_pml_kel4/features/user/domain/entities/booking_entity.dart';

abstract class UserRepository {
Future<List<BookingServiceEntity>> getOrderHistory(String status);

Future<void> createBooking(BookingServiceEntity booking);
}