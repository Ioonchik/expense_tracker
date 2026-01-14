import 'package:expense_tracker/models/expense.dart';

class ExpenseRepository {
  final List<Expense> _items = [];

  List<Expense> getAll() => List.unmodifiable(_items);

  void add(Expense e) => _items.add(e);

  void update(Expense updated) {
    final index = _items.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    _items[index] = updated;
  }

  void removeById(String id) {
    _items.removeWhere((e) => e.id == id);
  }
}
