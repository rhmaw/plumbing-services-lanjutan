import '../models/Booking_Service_models.dart';



abstract class BookingRemoteDataSource {
  Future<BookingServiceModel> getBooking(String status);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<BookingServiceModel> getBooking(String status) async {
    await Future.delayed(const Duration(seconds: 1));


    if (status == 'pending') {
      return BookingServiceModel(
        jobId: 1,
        workerName: 'Banu',
        serviceName: 'Ganti Pipa',
        date: DateTime(2025, 11, 29),
        time: '15:45',
        status: 'pending',
        totalPrice: 150000,
      );
    }

    if (status == 'accepted') {
      return BookingServiceModel(
        jobId: 2,
        workerName: 'Jiwa Sajewo',
        serviceName: 'Ganti Pipa',
        date: DateTime(2025, 11, 20),
        time: '15:45',
        status: 'accepted',
        totalPrice: 150000,
      );
    }

    if (status == 'rejected') {
      return BookingServiceModel(
        jobId: 3,
        workerName: 'Banu',
        serviceName: 'Ganti Pipa',
        date: DateTime(2025, 11, 18),
        time: '15:45',
        status: 'rejected',
        totalPrice: 150000,
      );
    }

    if (status == 'finished') {
      return BookingServiceModel(
        jobId: 4,
        workerName: 'Banu',
        serviceName: 'Ganti Pipa',
        date: DateTime(2025, 11, 15),
        time: '09:00',
        status: 'finished',
        totalPrice: 150000,
      );
    }


    throw Exception('Booking dengan status "$status" tidak ditemukan');
  }
}
