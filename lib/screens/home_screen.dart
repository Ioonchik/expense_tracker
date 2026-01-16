import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/services/storage_service.dart';
import 'package:expense_tracker/widget/expense_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<Expense> _expenses = [];
  bool _isLoading = true;

  double get total => getTotal(_expenses);

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

  double getTotal(List<Expense> expenses) {
    double total = 0.0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total expenses:',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 45, 45, 45),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${total.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _expenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return ExpenseTile(expense: expense);
                      },
                    ),
            ),
          ],
        ),
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
