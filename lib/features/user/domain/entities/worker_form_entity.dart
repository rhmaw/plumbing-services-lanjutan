class WorkerEntity {
  final String username;
  final String phone;
  final String email;
  final String password;
  final String address;
  final String gender;
  final List<String> skills;
  final String otherSkill;
  final String portfolio;

  WorkerEntity({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    required this.skills,
    required this.otherSkill,
    required this.portfolio,
  });
}
