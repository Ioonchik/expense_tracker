import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.onAddExpense,
    this.initialExpense,
  });

  final void Function(Expense expense)? onAddExpense;
  final Expense? initialExpense;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  Category _selectedCategory = Category.other;

  static const double _maxAmount = 1_000_000_000;

  String? _errorText;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    if (widget.initialExpense != null) {
      _titleController.text = widget.initialExpense!.title;
      _amountController.text = widget.initialExpense!.amount.toString();
      _selectedDate = widget.initialExpense!.date;
      _selectedCategory = widget.initialExpense!.category;
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateError = null;
    });
  }

  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Pick a date';
      });
    }

    if (!isValid || _selectedDate == null) return;
 
    final title = _titleController.text.trim();
    final rawAmount = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(rawAmount);

    if (widget.initialExpense != null) {
      final editedExpense = Expense(
        id: widget.initialExpense!.id,
        title: title,
        amount: amount!,
        date: _selectedDate!,
        category: _selectedCategory,
      );

      Navigator.pop(context, editedExpense);
    } else {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        amount: amount!,
        date: _selectedDate!,
        category: _selectedCategory,
      );

      widget.onAddExpense!(expense);
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Enter a title';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: 'Amount (₸)'),
                validator: (value) {
                  final raw = (value ?? '').trim();

                  if (raw.isEmpty) return 'Enter an amount';

                  final normalized = raw.replaceAll(',', '.');
                  final parsed = double.tryParse(normalized);

                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Amount must be greater than 0';
                  if (parsed > _maxAmount) {
                    return 'Amount must be less than ${_maxAmount.toStringAsFixed(0)}';
                  }

                  return null;
                },
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
              if (_dateError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsetsGeometry.only(top: 6),
                    child: Text(
                      _dateError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
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
                      child: widget.initialExpense != null
                          ? const Text('Save')
                          : const Text('Add expense'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
