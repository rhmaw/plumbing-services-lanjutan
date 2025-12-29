class User {
  final String name;
  final String email;
  final String phone;
  final String address;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });


  String? get role => null;

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
