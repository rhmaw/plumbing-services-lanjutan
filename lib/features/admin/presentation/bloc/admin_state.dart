import 'package:equatable/equatable.dart';

import '../../domain/entities/registration.dart';
import '../../domain/entities/salary.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

// === Registration ===
class RegistrationLoaded extends AdminState {
  final List<Registration> registrations;
  RegistrationLoaded(this.registrations);

  @override
  List<Object?> get props => [registrations];
}

/// =====================
/// WORKER DETAIL
/// =====================
class WorkerDetailLoaded extends AdminState {
  final Registration worker;

  WorkerDetailLoaded(this.worker);

  @override
  List<Object?> get props => [worker];
}

/// =====================

// === Salary ===
class SalaryLoaded extends AdminState {
  final Salary salary;
  SalaryLoaded(this.salary);

  @override
  List<Object?> get props => [salary];
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
