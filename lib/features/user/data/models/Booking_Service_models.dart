import '../../domain/entities/booking_entity.dart';


class BookingServiceModel extends Booking {
  BookingServiceModel({
    required super.jobId,
    required super.workerName,
    required super.serviceName,
    required super.date,
    required super.time,
    required super.status,
    required super.totalPrice,
  });


  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      jobId: json['job_id'] as int,
      workerName: json['worker_name'] as String,
      serviceName: json['service_name'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      status: json['status'] as String,
      totalPrice: json['total_price'] as int,
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'worker_name': workerName,
      'service_name': serviceName,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
      'total_price': totalPrice,
    };
  }

 
  factory BookingServiceModel.fromEntity(
    Booking entity,
  ) {
    return BookingServiceModel(
      jobId: entity.jobId,
      workerName: entity.workerName,
      serviceName: entity.serviceName,
      date: entity.date,
      time: entity.time,
      status: entity.status,
      totalPrice: entity.totalPrice,
    );
  }
}
