import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/admin.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/repositories/admin_repository.dart';

class GetAdminProfile {
  final AdminRepository repository;
  GetAdminProfile(this.repository);

  Future<Admin> call(String adminId) async {
    return await repository.getAdminProfile(adminId);
  }
}
