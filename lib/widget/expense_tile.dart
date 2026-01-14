import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(
          '${expense.category.name.toUpperCase()}\n'
          '${expense.date.day}.${expense.date.month}.${expense.date.year}',
        ),
        trailing: Text(
          '${expense.amount.toStringAsFixed(0)} ₸',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
