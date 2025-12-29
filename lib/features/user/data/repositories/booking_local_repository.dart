import '../../domain/entities/booking_entity.dart';


abstract class BookingLocalRepository {

  Future<List<Booking>> getBookingService(String status);


  Future<List<Booking>> getOrderHistory();

 
  Future<void> saveBooking(Booking booking);


  Future<void> clearAll();
}
