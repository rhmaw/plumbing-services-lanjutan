class Admin {
  final String adminId;
  final String email;
  final String username;

  const Admin({
    required this.adminId,
    required this.email,
    required this.username,
  });

  Admin copyWith({String? adminId, String? email, String? username}) {
    return Admin(
      adminId: adminId ?? this.adminId,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
}
