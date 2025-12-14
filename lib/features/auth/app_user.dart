class AppUser {
  final int? id;
  final String username;

  AppUser({
    this.id,
    required this.username,
  });

  factory AppUser.fromMap(Map<String, Object?> map) {
    return AppUser(
      id: map['id'] as int?,
      username: map['username'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'username': username,
    };
  }
}
