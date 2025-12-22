import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/admin.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/registration.dart';
import 'package:plumbing_services_pml_kel4/features/admin/domain/entities/worker.dart';

abstract class AdminRepository {
  Future<List<Registration>> getRegistrations();
  Future<void> acceptRegistration(String registrationId);
  Future<void> rejectRegistration(String registrationId);
  Future<int> getSalaryWorker(String workerId);
  Future<Worker> getWorkerDetail(String registrationId);
  Future<Admin> getAdminProfile(String adminId);
}
