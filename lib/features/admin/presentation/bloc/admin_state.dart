import 'package:equatable/equatable.dart';

import '../../domain/entities/admin.dart';
import '../../domain/entities/registration.dart';
import '../../domain/entities/worker.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationLoaded extends AdminState {
  final List<Registration> registrations;
  RegistrationLoaded(this.registrations);

  @override
  List<Object?> get props => [registrations];
}

class AcceptedRegistrationsLoaded extends AdminState {
  final List<Registration> acceptedRegistrations;
  AcceptedRegistrationsLoaded(this.acceptedRegistrations);

  @override
  List<Object?> get props => [acceptedRegistrations];
}

class WorkerDetailLoaded extends AdminState {
  final Worker worker;
  WorkerDetailLoaded(this.worker);

  @override
  List<Object?> get props => [worker];
}

class SalaryLoaded extends AdminState {
  final int salary;
  SalaryLoaded(this.salary);

  @override
  List<Object?> get props => [salary];
}

class AdminProfileLoaded extends AdminState {
  final Admin admin;
  AdminProfileLoaded(this.admin);

  @override
  List<Object?> get props => [admin];
}
