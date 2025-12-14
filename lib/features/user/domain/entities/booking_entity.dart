class BookingServiceEntity {
  final int jobId;
  final String workerName;
  final String serviceName;
  final DateTime date;
  final String time;
  final String status; // pending, accepted, rejected, finished
  final int totalPrice;

  BookingServiceEntity({
    required this.jobId,
    required this.workerName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    required this.totalPrice,
  });

  String? get difficulty => null;

  BookingServiceEntity copyWith({
    int? jobId,
    String? workerName,
    String? serviceName,
    DateTime? date,
    String? time,
    String? status,
    int? totalPrice,
  }) {
    return BookingServiceEntity(
      jobId: jobId ?? this.jobId,
      workerName: workerName ?? this.workerName,
      serviceName: serviceName ?? this.serviceName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
