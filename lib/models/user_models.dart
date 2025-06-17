class User {
  final String name;
  final String email;
  final String token;

  User({
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
