enum Category {
  food,
  transport,
  entertainment,
  other,
}

class Expense {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Expense copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
