import 'dart:convert';
import 'package:expense_tracker/models/expense.dart';
import 'package:hive/hive.dart';

class StorageService {
  static const _boxName = 'app_storage';
  static const _expenseKey = 'expenses';

  Future<Box> _openBox() async {
    return Hive.openBox(_boxName);
  }

  Future<List<Expense>> loadExpenses() async {
    final box = await _openBox();
    final raw = box.get(_expenseKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw as String) as List<dynamic>;
    return decoded
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final box = await _openBox();
    final encoded = jsonEncode(expenses.map((e) => e.toJson()).toList());
    await box.put(_expenseKey, encoded);
  }
}
