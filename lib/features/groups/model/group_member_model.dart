class GroupMember {
  final int userId;
  final int groupId;
  final double amountSpent;

  const GroupMember({
    required this.userId,
    required this.groupId,
    this.amountSpent = 0.0
  });

  // Konwersja z Mapy (pobieranie z bazy danych)
  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      userId: map['user_id'] as int,
      groupId: map['group_id'] as int,
      amountSpent: map['amount_spent'] as double
    );
  }

  // Konwersja na Mapę (zapisywanie do bazy danych)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'group_id': groupId,
      'amount_spent': amountSpent
    };
  }
}