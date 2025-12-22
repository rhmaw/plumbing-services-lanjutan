import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/worker.dart';

import '../repositories/admin_repository.dart';

class GetWorkerDetail {
  final AdminRepository repository;

  GetWorkerDetail(this.repository);

  Future<Worker> call(String registrationId) {
    return repository.getWorkerDetail(registrationId);
  }
}
