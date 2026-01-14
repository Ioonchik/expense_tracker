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

  DateTime? _selectedDate = DateTime.now();
  Category _selectedCategory = Category.other;

  String? _errorText;

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

  void _saveExpense() {
    final title = _titleController.text.trim();
    final rawAmount = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(rawAmount);

    if (title.isEmpty ||
        amount == null ||
        amount <= 0 ||
        _selectedDate == null) {
      setState(() {
        _errorText = 'Please fill all fields correctly';
      });
      return;
    }

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      amount: amount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(expense);
    Navigator.pop(context);
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
                setState(() => _selectedCategory = value);
              },
            ),

            const SizedBox(height: 16),
            if (_errorText != null) ...[
              Text(
                _errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

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
                      _saveExpense();
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
