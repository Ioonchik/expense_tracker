import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
  });

  final Expense expense;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          expense.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${expense.category.name.toUpperCase()}\n'
          '${expense.date.day}.${expense.date.month}.${expense.date.year}',
        ),
        isThreeLine: true,
        trailing: Text(
          '${expense.amount.toStringAsFixed(0)} ₸',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          onEdit();
        },
      ),
    );
  }
}
