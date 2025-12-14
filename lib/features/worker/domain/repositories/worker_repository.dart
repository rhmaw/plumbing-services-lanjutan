import '../entities/worker.dart';

abstract class WorkerRepository {

  Future<Worker> getWorkerById(int idWorker);

  Future<List<Worker>> getAvailableWorkers();

  Future<void> updateWorkerStatus({
    required int idWorker,
    required bool statusAvailable,
  });
}
