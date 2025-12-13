class Worker {
  final int idWorker;
  final int idAccount;
  final String role;
  final bool statusAvailable;

  Worker({
    required this.idWorker,
    required this.idAccount,
    required this.role,
    required this.statusAvailable,
  });


  Worker copyWith({
    int? idWorker,
    int? idAccount,
    String? role,
    bool? statusAvailable,
  }) {
    return Worker(
      idWorker: idWorker ?? this.idWorker,
      idAccount: idAccount ?? this.idAccount,
      role: role ?? this.role,
      statusAvailable: statusAvailable ?? this.statusAvailable,
    );
  }

  String get statusText => statusAvailable ? 'Available' : 'Not Available';
}
