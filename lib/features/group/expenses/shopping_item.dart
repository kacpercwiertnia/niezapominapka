class ShoppingItem {
  final String name;
  final double amount;

  const ShoppingItem({
    required this.name,
    required this.amount,
  });

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}