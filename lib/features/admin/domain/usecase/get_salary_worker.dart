import '../entities/salary.dart';
import '../repositories/admin_repository.dart';

class GetSalaryWorker {
  final AdminRepository repository;

  GetSalaryWorker(this.repository);

  Future<Salary> call(String workerId) {
    return repository.getSalaryWorker(workerId);
  }
}
