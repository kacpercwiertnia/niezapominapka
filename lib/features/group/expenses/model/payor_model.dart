class Payor {
  final int? id;
  final int userId;
  final String username;
  final double amount;

  Payor({
    this.id,
    required this.userId,
    required this.username,
    required this.amount,
  });

  // Konwersja z obiektu na Mapę (do zapisu w SQLite)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'username': username,
      'amount': amount,
    };
  }

  // Tworzenie obiektu z Mapy (przy pobieraniu z bazy)
  factory Payor.fromMap(Map<String, dynamic> map) {
    return Payor(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      username: map['username'] as String,
      amount: (map['amount'] as num).toDouble(), // Bezpieczne rzutowanie na double
    );
  }

  // Metoda copyWith ułatwia pracę ze stanem
  Payor copyWith({
    int? id,
    int? userId,
    String? username,
    double? amount,
  }) {
    return Payor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      amount: amount ?? this.amount,
    );
  }
}