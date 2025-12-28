class GroupMember {
  final int userId;
  final int groupId;

  const GroupMember({
    required this.userId,
    required this.groupId,
  });

  // Konwersja z Mapy (pobieranie z bazy danych)
  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      userId: map['user_id'] as int,
      groupId: map['group_id'] as int,
    );
  }

  // Konwersja na Mapę (zapisywanie do bazy danych)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'group_id': groupId,
    };
  }
}