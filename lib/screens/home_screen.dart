import 'dart:math';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/services/storage_service.dart';
import 'package:expense_tracker/widget/expense_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<Expense> _expenses = [];
  bool _isLoading = true;

  double get total => getTotal(_expenses);

  Category? _selectedCategory = null;

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

  List<Expense> get visibleExpenses {
    if (_selectedCategory == null) {
      return _expenses;
    }
    List<Expense> result = [];
    for (Expense expense in _expenses) {
      if (expense.category == _selectedCategory) {
        result.add(expense);
      }
    }
    return result;
  }

  void _editExpense(Expense expense) async {
    final editedExpense = await showModalBottomSheet<Expense>(
      context: context,
      builder: (context) {
        return AddExpenseScreen(initialExpense: expense);
      },
    );

    if (editedExpense == null) {
      return;
    }

    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].id == expense.id) {
        setState(() {
          _expenses[i] = editedExpense;
        });
        await _storage.saveExpenses(_expenses);
        break;
      }
    }
  }

  void _deleteExpense(Expense expense) {
    setState(() {
      _expenses.remove(expense);
      _storage.saveExpenses(_expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],
      ),
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
                      children: [
                        Text(
                          'Total expenses:',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${total.toStringAsFixed(2)}',
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
            Padding(
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                    (_selectedCategory == null
                        ? OutlinedButton(
                            onPressed: () {
                              _selectedCategory = null;
                              setState(() {});
                            },
                            child: Text('All'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _selectedCategory = null;
                              setState(() {});
                            },
                            child: Text('All'),
                          )),
                    (_selectedCategory != Category.food
                        ? ElevatedButton(
                            onPressed: () {
                              _selectedCategory = Category.food;
                              setState(() {});
                            },
                            child: Text('Food'),
                          )
                        : OutlinedButton(
                            onPressed: () {
                              _selectedCategory = Category.food;
                              setState(() {});
                            },
                            child: Text('Food'),
                          )),
                    (_selectedCategory != Category.transport
                        ? ElevatedButton(
                            onPressed: () {
                              _selectedCategory = Category.transport;
                              setState(() {});
                            },
                            child: Text('Transport'),
                          )
                        : OutlinedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text('Transport'),
                          )),
                    (_selectedCategory != Category.entertainment
                        ? ElevatedButton(
                            onPressed: () {
                              _selectedCategory = Category.entertainment;
                              setState(() {});
                            },
                            child: Text('Entertainment'),
                          )
                        : OutlinedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text('Entertainment'),
                          )),
                    (_selectedCategory != Category.other
                        ? ElevatedButton(
                            onPressed: () {
                              _selectedCategory = Category.other;
                              setState(() {});
                            },
                            child: Text('Other'),
                          )
                        : OutlinedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text('Other'),
                          )),
                  ],
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
                      itemCount: visibleExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = visibleExpenses[index];
                        return ExpenseTile(
                          expense: expense,
                          onEdit: () => _editExpense(expense),
                          onDelete: () => _deleteExpense(expense),
                        );
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
