import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRegistrationsEvent extends AdminEvent {}

class LoadWorkerDetailEvent extends AdminEvent {
  final int registrationId;
  LoadWorkerDetailEvent(this.registrationId);

  @override
  List<Object?> get props => [registrationId];
}

class AcceptRegistrationEvent extends AdminEvent {
  final int registrationId;
  AcceptRegistrationEvent(this.registrationId);

  @override
  List<Object?> get props => [registrationId];
}

class LoadAcceptedRegistrationsEvent extends AdminEvent {}

class RejectRegistrationEvent extends AdminEvent {
  final int registrationId;
  RejectRegistrationEvent(this.registrationId);

  @override
  List<Object?> get props => [registrationId];
}

class LoadSalaryWorkerEvent extends AdminEvent {
  final int workerId;
  LoadSalaryWorkerEvent(this.workerId);

  @override
  List<Object?> get props => [workerId];
}

class LoadAdminProfileEvent extends AdminEvent {
  final int adminId;
  LoadAdminProfileEvent(this.adminId);

  @override
  List<Object?> get props => [adminId];
}
