class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'type': type.toString(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.expense,
      ),
    );
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }
}

enum TransactionType {
  income,
  expense,
}

class Category {
  final String name;
  final String icon;
  final String color;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<Category> categories = [
    Category(name: 'Yemek', icon: '🍕', color: '#F97316'),
    Category(name: 'Fatura', icon: '💡', color: '#3B82F6'),
    Category(name: 'Ulaşım', icon: '🚗', color: '#8B5CF6'),
    Category(name: 'Maaş', icon: '💰', color: '#10B981'),
    Category(name: 'Alışveriş', icon: '🛍️', color: '#EC4899'),
    Category(name: 'Konut', icon: '🏠', color: '#F59E0B'),
    Category(name: 'Eğlence', icon: '🎮', color: '#06B6D4'),
    Category(name: 'Sağlık', icon: '🏥', color: '#EF4444'),
  ];
}
