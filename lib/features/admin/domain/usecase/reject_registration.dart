import 'package:plumbing_services_pml_kel4/features/admin/domain/repositories/admin_repository.dart';

class RejectRegistration {
  final AdminRepository repository;

  RejectRegistration(this.repository);

  Future<void> call(String id) {
    return repository.rejectRegistration(id);
  }
}
