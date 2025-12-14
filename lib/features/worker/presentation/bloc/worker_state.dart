import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/worker.dart';


abstract class WorkerState extends Equatable {
const WorkerState();


@override
List<Object?> get props => [];
}


class WorkerInitial extends WorkerState {}


class WorkerLoading extends WorkerState {}


class WorkerLoaded extends WorkerState {
	final Worker worker;
	final List<Order> waiting;
	final List<Order> accepted;
	final List<Order> finished;

	const WorkerLoaded({
		required this.worker,
		required this.waiting,
		required this.accepted,
		required this.finished,
	});

	@override
	List<Object?> get props => [worker, waiting, accepted, finished];
}


class WorkerError extends WorkerState {
final String message;


const WorkerError(this.message);


@override
List<Object?> get props => [message];
}


class WorkerActionSuccess extends WorkerState {
	final String message;

	const WorkerActionSuccess(this.message);

	@override
	List<Object?> get props => [message];
}