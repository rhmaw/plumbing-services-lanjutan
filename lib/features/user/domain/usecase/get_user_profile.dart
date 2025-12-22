import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<UserEntity> execute() async {
    return await repository.getUserProfile();
  }
}
