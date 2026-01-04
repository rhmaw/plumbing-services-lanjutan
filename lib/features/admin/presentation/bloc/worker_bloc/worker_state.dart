import 'package:equatable/equatable.dart';

abstract class WorkerState extends Equatable {
  const WorkerState();
  
  @override
  List<Object> get props => [];
}

class WorkerInitial extends WorkerState {}

class WorkerLoading extends WorkerState {}

class WorkerLoaded extends WorkerState {
  final List<dynamic> workers;
  final List<dynamic> filteredWorkers;

  const WorkerLoaded({required this.workers, required this.filteredWorkers});

  @override
  List<Object> get props => [workers, filteredWorkers];
}

class WorkerError extends WorkerState {
  final String message;
  const WorkerError(this.message);

  @override
  List<Object> get props => [message];
}