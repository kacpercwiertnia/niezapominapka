
class Expense {
  final int? id;
  final int userId; // Dodane pole userId
  final int groupId;
  final DateTime date;
  final String name;
  final double amount;

  const Expense({
    this.id,
    required this.groupId,
    required this.userId,
    required this.date,
    required this.name,
    required this.amount
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      groupId: map['group_id'] as int,
      userId: map['user_id'] as int, // Mapowanie z bazy danych
      date: DateTime.parse(map['date'] as String),
      name: map['name'] as String,
      amount: map['amount'] as double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId, // Nazwa kolumny w bazie danych
      'group_id': groupId,
      'date': date.toIso8601String(),
      // Zauważ: items zazwyczaj zapisujemy w osobnej tabeli,
      // ale toMap() zachowuje tę strukturę dla spójności
      'name': name,
      'amount': amount
    };
  }

  // Pomocnicza metoda do tworzenia kopii obiektu ze zmienionymi polami
  Expense copyWith({
    int? id,
    int? userId,
    int? groupId,
    DateTime? date,
    String? name,
    double? amount
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      name: name ?? this.name,
      amount: amount ?? this.amount
    );
  }
}