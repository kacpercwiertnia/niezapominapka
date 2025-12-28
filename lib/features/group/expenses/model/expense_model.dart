import 'package:niezapominapka/features/group/expenses/model/shopping_item.dart';

class Expense {
  final int? id;
  final int userId; // Dodane pole userId
  final DateTime date;
  final List<ShoppingItem> items;

  const Expense({
    this.id,
    required this.userId,
    required this.date,
    required this.items,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      userId: map['user_id'] as int, // Mapowanie z bazy danych
      date: DateTime.parse(map['date'] as String),
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => ShoppingItem.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [], // Bezpieczna obsługa pustej listy
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId, // Nazwa kolumny w bazie danych
      'date': date.toIso8601String(),
      // Zauważ: items zazwyczaj zapisujemy w osobnej tabeli,
      // ale toMap() zachowuje tę strukturę dla spójności
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Pomocnicza metoda do tworzenia kopii obiektu ze zmienionymi polami
  Expense copyWith({
    int? id,
    int? userId,
    DateTime? date,
    List<ShoppingItem>? items,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);
}