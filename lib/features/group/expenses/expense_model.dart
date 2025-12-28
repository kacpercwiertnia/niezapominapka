import 'package:niezapominapka/features/group/expenses/shopping_item.dart';

class Expense {
  final int? id; // Opcjonalne ID
  final DateTime date;
  final List<ShoppingItem> items;

  const Expense({
    this.id,
    required this.date,
    required this.items,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      // Mapujemy listę przedmiotów, jeśli istnieje w mapie
      items: (map['items'] as List<dynamic>)
          .map((item) => ShoppingItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(), // Zapisujemy jako tekst: "2023-10-27T..."
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Opcjonalnie: helper do sumowania kwot
  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);
}