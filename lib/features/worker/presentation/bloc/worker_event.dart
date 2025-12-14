import 'package:equatable/equatable.dart';

abstract class WorkerEvent extends Equatable {
  const WorkerEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkerEvent extends WorkerEvent {
  final int workerId;

  const LoadWorkerEvent(this.workerId);

  @override
  List<Object?> get props => [workerId];
}

class AcceptOrderEvent extends WorkerEvent {
  final int orderId;

  const AcceptOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateWorkerStatusEvent extends WorkerEvent {
  final bool statusAvailable;

  const UpdateWorkerStatusEvent(this.statusAvailable);

  @override
  List<Object?> get props => [statusAvailable];
}