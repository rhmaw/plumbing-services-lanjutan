// lib/features/admin/data/models/registration_model.dart
import '../../domain/entities/registration.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    required String registrationId,
    required String name,
    required String email,
    required String skill,
  }) : super(
         registrationId: registrationId,
         name: name,
         email: email,
         skill: skill,
       );

  Map<String, dynamic> toMap() {
    return {
      'registrationId': registrationId,
      'name': name,
      'email': email,
      'skill': skill,
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      registrationId: map['registrationId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      skill: map['skill'] ?? '',
    );
  }
}
