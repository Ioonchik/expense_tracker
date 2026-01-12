import 'dart:math';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  ExpenseTile({super.key});

  final List<Expense> dummyExpenses = [
    Expense(
      id: 1,
      title: 'Arbuz',
      amount: 10000,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      id: 2,
      title: 'Bus',
      amount: 110,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.transport,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyExpenses.length,
      itemBuilder: (context, index) {
        final expense = dummyExpenses[index];

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
      },
    );
  }
}
