import '../repositories/admin_repository.dart';

class GetSalaryWorker {
  final AdminRepository repository;

  GetSalaryWorker(this.repository);

  Future<int> call(String workerId) {
    return repository.getSalaryWorker(workerId);
  }
}
