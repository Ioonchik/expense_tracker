import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.other;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title:'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: 'Amount:'),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      _selectedDate == null
                          ? 'Pick date'
                          : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<Category>(
              initialValue: _selectedCategory,
              items: Category.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCategory = value,);
              },
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final expense = Expense(
                        id: 1,
                        title: 'Test',
                        amount: 100,
                        date: DateTime.now(),
                        category: Category.other,
                      );

                      widget.onAddExpense(expense);
                      Navigator.pop(context);
                    },
                    child: const Text('Add test expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
