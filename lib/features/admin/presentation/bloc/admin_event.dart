abstract class AdminEvent {}

/// Load semua pendaftaran worker
class LoadRegistrationsEvent extends AdminEvent {}

/// Load detail worker berdasarkan registrationId
class LoadWorkerDetailEvent extends AdminEvent {
  final String registrationId;

  LoadWorkerDetailEvent(this.registrationId);
}

/// Accept pendaftaran
class AcceptRegistrationEvent extends AdminEvent {
  final String registrationId;

  AcceptRegistrationEvent(this.registrationId);
}

/// Reject pendaftaran
class RejectRegistrationEvent extends AdminEvent {
  final String registrationId;

  RejectRegistrationEvent(this.registrationId);
}

/// Load gaji worker
class LoadSalaryWorkerEvent extends AdminEvent {
  final String workerId;

  LoadSalaryWorkerEvent(this.workerId);
}
