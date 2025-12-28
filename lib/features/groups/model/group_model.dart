class Group {
  final int? id;
  final String name;

  Group({
    this.id,
    required this.name,
  });

  factory Group.fromMap(Map<String, Object?> map) {
    return Group(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
