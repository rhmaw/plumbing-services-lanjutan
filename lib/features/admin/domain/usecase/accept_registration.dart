import 'package:plumbing_services_pml_kel4/features/admin/domain/repositories/admin_repository.dart';

class AcceptRegistration {
  final AdminRepository repository;

  AcceptRegistration(this.repository);

  Future<void> call(String id) {
    return repository.acceptRegistration(id);
  }
}
