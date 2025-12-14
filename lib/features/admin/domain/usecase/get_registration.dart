import '../entities/registration.dart';
import '../repositories/admin_repository.dart';

class GetRegistrations {
  final AdminRepository repository;

  GetRegistrations(this.repository);

  Future<List<Registration>> call() {
    return repository.getRegistrations();
  }
}
