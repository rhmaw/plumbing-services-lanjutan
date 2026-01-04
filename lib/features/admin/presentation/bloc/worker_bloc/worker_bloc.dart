import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/api/auth_service.dart';
import 'worker_event.dart';
import 'worker_state.dart';

class WorkerBloc extends Bloc<WorkerEvent, WorkerState> {
  final AuthService authService;

  WorkerBloc(this.authService) : super(WorkerInitial()) {
    
    on<LoadWorkers>((event, emit) async {
      emit(WorkerLoading());
      try {
        final data = await authService.getWorkerApplications();
        emit(WorkerLoaded(workers: data, filteredWorkers: data));
      } catch (e) {
        emit(WorkerError(e.toString()));
      }
    });

    on<SearchWorkers>((event, emit) {
      if (state is WorkerLoaded) {
        final currentState = state as WorkerLoaded;
        final query = event.query.toLowerCase();
        
        final results = currentState.workers.where((user) {
          final name = (user['name'] ?? '').toString().toLowerCase();
          return name.contains(query);
        }).toList();

        emit(WorkerLoaded(
          workers: currentState.workers, 
          filteredWorkers: results
        ));
      }
    });
  }
}