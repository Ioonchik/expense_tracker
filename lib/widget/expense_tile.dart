import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, required this.onEdit, required this.onDelete});

  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(expense.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
        onLongPress: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text('Delete ${expense.title}?'),
              content: Text('This action cannot be undone'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
