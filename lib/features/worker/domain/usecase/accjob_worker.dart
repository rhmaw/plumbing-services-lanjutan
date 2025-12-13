import '../entities/worker.dart';
import '../repositories/worker_repository.dart';

class AccJobWorker {
  final WorkerRepository repository;

  AccJobWorker(this.repository);

  Future<Worker> acceptJob(Worker worker) async {
    await repository.updateWorkerStatus(
      idWorker: worker.idWorker,
      statusAvailable: false,
    );

    return worker.copyWith(statusAvailable: false);
  }

  Future<Worker> rejectJob(Worker worker) async {
    await repository.updateWorkerStatus(
      idWorker: worker.idWorker,
      statusAvailable: true,
    );

    return worker.copyWith(statusAvailable: true);
  }
}
