// lib/features/admin/data/data_source/admin_local_data_source.dart
import '../models/registration_model.dart';

class AdminLocalDataSource {
  final List<RegistrationModel> _registrations = [];
  final List<RegistrationModel> _acceptedRegistrations = [];

  Future<void> saveRegistrations(List<RegistrationModel> registrations) async {
    _registrations.clear();
    _registrations.addAll(registrations);
  }

  Future<List<RegistrationModel>> getRegistrations() async {
    return List.unmodifiable(_registrations);
  }

  Future<void> saveAcceptedRegistration(RegistrationModel registration) async {
    _acceptedRegistrations.add(registration);
    _registrations.removeWhere(
      (r) => r.registrationId == registration.registrationId,
    );
  }

  Future<List<RegistrationModel>> getAcceptedRegistrations() async {
    return List.unmodifiable(_acceptedRegistrations);
  }

  Future<void> clearRegistrations() async {
    _registrations.clear();
  }

  Future<void> clearAcceptedRegistrations() async {
    _acceptedRegistrations.clear();
  }
}
