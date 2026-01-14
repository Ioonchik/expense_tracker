import 'package:expense_tracker/data/expense_repository.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: expenses.isEmpty
          ? const Center(
              child: Text('No expenses yet', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
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
                  setState(() {
                    repo.add(expense);
                  });
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
