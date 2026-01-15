import 'package:expense_tracker/data/expense_repository.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/services/storage_service.dart';
import 'package:expense_tracker/widget/expense_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = ExpenseRepository();
  List<Expense> get expenses => repo.getAll();

  final _storage = StorageService();
  List<Expense> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _storage.loadExpenses();
    setState(() {
      _expenses = loaded;
      _isLoading = false;
    });
  }

  Future<void> _addExpense(Expense expense) async {
    setState(() {
      _expenses = [..._expenses, expense];
    });
    await _storage.saveExpenses(_expenses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _expenses.isEmpty
          ? const Center(
              child: Text('No expenses yet', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ExpenseTile(expense: expense);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddExpenseScreen(
                onAddExpense: (expense) {
                  _addExpense(expense);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
