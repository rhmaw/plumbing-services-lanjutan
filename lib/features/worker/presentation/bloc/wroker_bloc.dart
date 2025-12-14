import 'package:flutter_bloc/flutter_bloc.dart';

import 'worker_event.dart';
import 'worker_state.dart';

import '../../domain/repositories/worker_repository.dart';

class WorkerBloc extends Bloc<WorkerEvent, WorkerState> {
  final WorkerRepository workerRepository;

  WorkerBloc({required this.workerRepository}) : super(WorkerInitial()) {
    on<LoadWorkerEvent>(_onLoadWorker);
    on<AcceptOrderEvent>(_onAcceptOrder);
    on<UpdateWorkerStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onLoadWorker(
    LoadWorkerEvent event,
    Emitter<WorkerState> emit,
  ) async {
    emit(WorkerLoading());
    try {
      final worker = await workerRepository.getWorkerById(event.workerId);
      emit(WorkerLoaded(
        worker: worker,
        waiting: const [],
        accepted: const [],
        finished: const [],
      ));
    } catch (_) {
      emit(const WorkerError('Failed to load worker data'));
    }
  }

  Future<void> _onAcceptOrder(
    AcceptOrderEvent event,
    Emitter<WorkerState> emit,
  ) async {
    try {

      emit(const WorkerActionSuccess('Order accepted'));
    } catch (_) {
      emit(const WorkerError('Failed to accept order'));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateWorkerStatusEvent event,
    Emitter<WorkerState> emit,
  ) async {
    if (state is! WorkerLoaded) return;

    final currentState = state as WorkerLoaded;
    final currentWorker = currentState.worker;

    try {
      await workerRepository.updateWorkerStatus(
        idWorker: currentWorker.idWorker,
        statusAvailable: event.statusAvailable,
      );

      final updated = currentWorker.copyWith(statusAvailable: event.statusAvailable);

      emit(WorkerLoaded(
        worker: updated,
        waiting: currentState.waiting,
        accepted: currentState.accepted,
        finished: currentState.finished,
      ));
    } catch (_) {
      emit(const WorkerError('Failed to update worker status'));
    }
  }
}
